'use strict';

const productModel = require('../models/product.model');
const fs = require('fs')
const path = require('path');
const mongoose = require('mongoose');
const { BadRequestError, AuthFailureError } = require('../core/error.response');

class ProductService {
    static async createProduct(req, res) {
        try {
            const { title, nameProduct, price, recap, description, specifications, category, } = req.body
            let image_filename = "";
            if (req.files) {
                image_filename = req.files.map(file => file.filename);
            } else {
                throw new Error("No file uploaded");
            }

            const newProduct = new productModel({
                title, nameProduct, price, category,
                images: image_filename,
                recap, description, specifications
            });
            const product = await newProduct.save();

            return {
                product
            }
        } catch (error) {
            throw error
        }
    }

    static async getProduct() {
        try {
            const product = await productModel.find()
                .select('title nameProduct price images category active')
                .sort({ createdAt: -1 })
                .exec();

            return { product };
        } catch (error) {
            throw error;
        }
    }

    static async getProductById(req, res) {
        try {
            const { id } = req.params;
            const product = await productModel.findById(id);
            return {
                product,
            }
        } catch (error) {
            throw error;
        }
    }

    static async getProductByslug(req, res) {
        try {
            const { product_slug } = req.params;
            const product = await productModel.findOne({ product_slug });
            return {
                product,
            }
        } catch (error) {
            throw error;
        }
    }


    static async updateProduct(req, res) {
        try {
            const productId = req.params.id;
            const { title, nameProduct, price, recap, description, category, quantity, specifications } = req.body;

            const updates = {
                title, nameProduct, price, recap, description, category, quantity, specifications
            };

            Object.keys(updates).forEach(key => updates[key] === undefined && delete updates[key]);
            const updatedProduct = await productModel.findByIdAndUpdate(productId, updates, { new: true });

            if (!updatedProduct) {
                throw new BadRequestError('Không tìm thấy sản phẩm');
            }

            await updatedProduct.save();

            return { product: updatedProduct }
        } catch (error) {
            throw error;
        }
    };

    static async deleteProduct(req, res) {
        try {
            const { id } = req.params;
            const product = await productModel.findById(id);

            if (!product) {
                throw new Error('Product not found');
            }

            if (product.images && product.images.length > 0) {
                // Lặp qua mảng images và xóa tất cả hình ảnh
                const deleteImagePromises = product.images.map(image => {
                    const imagePath = path.join(__dirname, '../../upload', image); // Tạo đường dẫn đầy đủ
                    return new Promise((resolve, reject) => {
                        fs.access(imagePath, fs.constants.F_OK, (err) => {
                            if (err) {
                                console.warn(`Image not found: ${imagePath}`);
                                return resolve(); // Nếu hình ảnh không tồn tại, bỏ qua
                            }

                            fs.unlink(imagePath, (err) => {
                                if (err) {
                                    console.error(`Error deleting image: ${imagePath}`, err);
                                    return reject(err);
                                }
                                console.log(`Image deleted: ${imagePath}`);
                                resolve();
                            });
                        });
                    });
                });

                // Chờ cho tất cả hình ảnh được xóa
                await Promise.all(deleteImagePromises);
            } else {
                console.warn('No images to delete.');
            }

            await productModel.findByIdAndDelete(id)

            return {
                product
            }
        } catch (error) {
            throw error;
        }
    }

    static async softRestoreProduct(req) {
        const { id } = req.params;
        const product = await productModel.findById(id)
        const newActiveStatus = !product.active;

        product.active = newActiveStatus;
        await product.save();

        return { metadata: product }
    }

    static async getProductByName(req, res) {
        try {
            const { nameProduct } = req.params;
            const product = await productModel.find({ nameProduct: { $regex: nameProduct, $options: 'i' } });
            return {
                metadata: product,
            }
        } catch (error) {
            throw error;
        }
    }

    static async getProductByCategory(req, res) {
        try {
            const { category } = req.params;
            const product = await productModel.find({ category })
                .select('title nameProduct product_slug price images category active')
                .sort({ createdAt: -1 })
                .exec();;
            return product;
        } catch (error) {
            throw error;
        }
    }

    static async getCountProduct() {
        return await productModel.countDocuments();
    }

    static async getProductsByPage(req, res) {
        try {
            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 10;
            const skip = (page - 1) * limit;

            const products = await productModel.find({ active: true })
                .select('title nameProduct product_slug price images category quantity active')
                .sort({ createdAt: -1 })
                .skip(skip)
                .limit(limit)
                .exec();

            const totalProducts = await productModel.countDocuments({ active: true });
            const totalPages = Math.ceil(totalProducts / limit);

            return {
                metadata: {
                    products,
                    currentPage: page,
                    totalPages,
                    totalProducts,
                    limit
                }
            };
        } catch (error) {
            throw error;
        }
    }

    static async paginateProductTrash(req, res) {
        try {
            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 10;
            const skip = (page - 1) * limit;

            const products = await productModel.find({ active: false })
                .select('title nameProduct product_slug price images category quantity active')
                .sort({ createdAt: -1 })
                .skip(skip)
                .limit(limit)
                .exec();

            const totalProducts = await productModel.countDocuments({ active: false });
            const totalPages = Math.ceil(totalProducts / limit);

            return {
                metadata: {
                    products,
                    currentPage: page,
                    totalPages,
                    totalProducts,
                    limit
                }
            };
        } catch (error) {
            throw error;
        }
    }

    static async updateQuantityProduct(req, res) {
        try {
            const { items } = req.body;
            // console.log("items: ", items)
            if (!items || !Array.isArray(items) || items.length === 0) {
                return res.status(400).json({ message: "Items must be a non-empty array" });
            }

            // use transaction
            const session = await mongoose.startSession();
            session.startTransaction();

            try {
                for (const item of items) {
                    const itemId = item._id;
                    const { quantity } = item;
                    // console.log("itemId: ", itemId)
                    if (!itemId || !quantity || quantity <= 0) {
                        throw new Error(`Invalid itemId or quantity for item: ${JSON.stringify(item)}`);
                    }

                    const product = await productModel.findOne({
                        _id: itemId,
                        active: true
                    }).session(session);

                    if (!product) {
                        throw new Error(`Product with itemId ${itemId} not found or not active`);
                    }

                    if (product.quantity < quantity) {
                        throw new Error(`Không thể thanh toán ${product.nameProduct}. Có sẵn: ${product.quantity}, Mua: ${quantity}`);
                    }

                    product.quantity -= quantity;

                    await product.save({ session });
                }

                await session.commitTransaction();

                return;

            } catch (error) {
                if (session.inTransaction()) {
                    await session.abortTransaction();
                }
                throw error;
            } finally {
                session.endSession();
            }

        } catch (error) {
            throw error;
        }
    }

}
module.exports = ProductService;