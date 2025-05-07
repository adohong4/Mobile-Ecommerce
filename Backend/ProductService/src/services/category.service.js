'use strict';

const categoryModel = require('../models/category.model');
const cloudinary = require('../config/cloudinary.config');
const { BadRequestError } = require('../core/error.response');

class CategoryService {
    static async createCategory(req, res) {
        try {
            const { category, categoryIds } = req.body;

            if (!category || !categoryIds) {
                throw new BadRequestError('Tên danh mục và ID danh mục là bắt buộc');
            }

            let imageUrl = '';
            if (req.file) {
                try {
                    // Upload ảnh từ buffer của multer lên Cloudinary
                    const uploadResponse = await new Promise((resolve, reject) => {
                        cloudinary.uploader.upload_stream({
                            resource_type: 'image',
                        }, (error, result) => {
                            if (error) {
                                return reject(new BadRequestError('Lỗi khi upload ảnh lên Cloudinary'));
                            }
                            resolve(result);
                        }).end(req.file.buffer);
                    });

                    imageUrl = uploadResponse.secure_url;
                } catch (error) {
                    throw new BadRequestError('Lỗi khi upload ảnh: ' + error.message);
                }
            }

            const newCategory = await categoryModel.create({
                category,
                categoryIds,
                categoryPic: imageUrl,
            });

            return { newCategory };
        } catch (error) {
            throw error;
        }
    }

    static async getCategoryList(req, res) {
        try {
            const category = await categoryModel.find()
                .sort({ createdAt: -1 })
                .exec();
            return category;
        } catch (error) {
            throw error;
        }
    }

    static async getCategoryById(req, res) {
        try {
            const { categoryId } = req.params;
            const category = await categoryModel.findById(categoryId);
            return category;
        } catch (error) {
            throw error;
        }
    }

    static async softDeleteCategory(req, res) {
        try {
            const { categoryId } = req.params;

            const category = await categoryModel.findByIdAndUpdate(
                categoryId,
                { active: false },
                { new: true }
            );

            return;
        } catch (error) {
            throw error;
        }
    };

    static async deleteCategory(req, res) {
        try {
            const { categoryId } = req.params;

            if (!categoryId) {
                throw new BadRequestError('ID danh mục là bắt buộc');
            }

            const category = await categoryModel.findById(categoryId);
            if (!category) {
                throw new BadRequestError('Danh mục không tồn tại');
            }

            if (category.categoryPic) {
                try {
                    const urlParts = category.categoryPic.split('/');
                    const fileName = urlParts[urlParts.length - 1];
                    const publicId = fileName.split('.')[0];

                    const destroyResult = await cloudinary.uploader.destroy(publicId);
                } catch (cloudinaryError) {
                    console.error('Lỗi khi xóa ảnh trên Cloudinary:', cloudinaryError);
                }
            }

            await categoryModel.findByIdAndDelete(categoryId);

            return;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = CategoryService;
