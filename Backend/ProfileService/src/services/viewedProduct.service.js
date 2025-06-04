'use strict';

const profileModel = require('../models/profile.model');
const { BadRequestError } = require("../core/error.response");

class ViewedProductService {
    static async getViewedProducts(req, res) {
        try {
            const userId = req.user._id;
            const profile = await profileModel.findOne({ userId }, 'viewedProducts');

            const currentTime = new Date();
            const viewedProducts = profile?.viewedProducts
                ?.filter(product => {
                    const viewedAt = new Date(product.viewedAt);
                    const daysDiff = (currentTime - viewedAt) / (1000 * 60 * 60 * 24);
                    return daysDiff <= 3;
                })
                .slice(0, 5)
                .map(product => product.productId) || [];

            return viewedProducts;
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

            // Thêm sản phẩm mới với thời gian xem
            const profile = await profileModel.findOneAndUpdate(
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

            // Trả về 5 productId đầu tiên còn hạn
            const viewedProducts = profile.viewedProducts
                ?.filter(product => {
                    const viewedAt = new Date(product.viewedAt);
                    const daysDiff = (new Date() - viewedAt) / (1000 * 60 * 60 * 24);
                    return daysDiff <= 3;
                })
                .slice(0, 5)
                .map(product => product.productId) || [];

            return viewedProducts;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = ViewedProductService;