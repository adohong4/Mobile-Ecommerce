'use strict';

const profileModel = require('../models/profile.model');
const { BadRequestError } = require("../core/error.response");

class ViewedProductService {
    static async getViewedProducts(req, res) {
        try {
            const userId = req.user._id;
            const profile = await profileModel.findOne({ userId }, 'viewedProducts');

            const threeDaysAgo = new Date(Date.now() - 3 * 24 * 60 * 60 * 1000);

            const viewedProductIds = profile?.viewedProducts
                .filter(product => new Date(product.viewedAt) >= threeDaysAgo)
                .sort((a, b) => new Date(b.viewedAt) - new Date(a.viewedAt))
                .slice(0, 5)
                .map(product => product.productId) || [];

            return viewedProductIds;
        } catch (error) {
            throw error;
        }
    }

    static async addViewedProduct(req, res) {
        try {
            const userId = req.user._id;
            const { productId } = req.body;

            if (!productId) {
                throw new BadRequestError('Yêu cầu phải có ID sản phẩm');
            }

            // Xóa sản phẩm hết hạn (hơn 3 ngày)
            await profileModel.updateOne(
                { userId },
                {
                    $pull: {
                        viewedProducts: {
                            viewedAt: { $lt: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000) }
                        }
                    }
                }
            );

            // Kiểm tra xem productId đã tồn tại chưa
            const profile = await profileModel.findOne({ userId });
            const existingProduct = profile?.viewedProducts?.find(
                product => product.productId.toString() === productId.toString()
            );

            if (existingProduct) {
                // Nếu sản phẩm đã tồn tại, cập nhật thời gian viewedAt
                await profileModel.updateOne(
                    { userId, 'viewedProducts.productId': productId },
                    {
                        $set: {
                            'viewedProducts.$.viewedAt': new Date()
                        }
                    }
                );
            } else {
                // Nếu sản phẩm chưa tồn tại, thêm mới vào danh sách
                await profileModel.findOneAndUpdate(
                    { userId },
                    {
                        $addToSet: {
                            viewedProducts: {
                                productId,
                                viewedAt: new Date()
                            }
                        }
                    },
                    { new: true, runValidators: true, upsert: true }
                );
            }

            // Lấy profile sau khi cập nhật
            const updatedProfile = await profileModel.findOne({ userId });

            return updatedProfile;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = ViewedProductService;