'use strict';

const commentModel = require('../models/comment.model');
const orderModel = require('../models/order.model');
const userModel = require('../models/profile.model');
const { Types } = require('mongoose');
const { BadRequestError, ForbiddenError } = require('../core/error.response');

class CommentService {
    static async commentProduct(req, res) {
        try {
            const userId = req.user._id;
            const { orderId, productId, comment, rating } = req.body;

            if (!orderId || !productId || !comment || !rating) {
                throw new BadRequestError('Thiếu thông tin bắt buộc');
            }

            // Kiểm tra đơn hàng
            const order = await orderModel.findOne({
                _id: orderId,
                userId,
                'items.id': productId,
                status: 'delivered',
                payment: true,
                active: true
            });

            if (!order) {
                throw new ForbiddenError('Bạn chỉ có thể bình luận sau khi mua và nhận sản phẩm');
            }

            const existingComment = await commentModel.findOne({
                productId,
                userId,
                active: true
            });

            if (existingComment) {
                throw new BadRequestError('Bạn đã bình luận cho sản phẩm này');
            }

            let imageFilenames = [];
            if (req.files && Array.isArray(req.files)) {
                imageFilenames = req.files.map(file => file.filename);
            }

            const newComment = new commentModel({
                productId,
                userId,
                comment,
                rating,
                images: imageFilenames,
                createdAt: new Date()
            });

            const savedComment = await newComment.save();

            return savedComment;

        } catch (error) {
            throw error;
        }
    }

    static async getCommentProduct(req, res) {
        try {
            const { productId } = req.params;
            const comment = await commentModel.find({ productId })
                .sort({ createdAt: -1 })
                .exec();
            return comment;
        } catch (error) {
            throw error;
        }
    }

    static async getCommentByUser(req, res) {
        try {
            const userId = req.user._id;
            const comment = await commentModel.find({ userId })
                .sort({ createdAt: -1 })
                .exec();
            return comment;
        } catch (error) {
            throw error;
        }
    }

    static async deleteComment(req, res) {
        try {
            const userId = req.user._id;
            const { commentId } = req.params;

            const existingComment = await commentModel.findById(commentId);
            if (!existingComment) {
                throw new NotFoundError('Không tìm thấy bình luận');
            }

            if (existingComment.userId.toString() !== userId.toString()) {
                throw new ForbiddenError('Bạn không có quyền xóa bình luận này');
            }

            if (existingComment.image && existingComment.image.length > 0) {
                const deleteImagePromises = existingComment.image.map(async (image) => {
                    const imagePath = path.join(__dirname, '../../upload', image);
                    try {
                        await fs.access(imagePath);
                        await fs.unlink(imagePath);
                        console.log(`Đã xóa hình ảnh: ${imagePath}`);
                    } catch (err) {
                        console.warn(`Hình ảnh không tồn tại: ${imagePath}`);
                    }
                });
                await Promise.all(deleteImagePromises);
            }

            await commentModel.findByIdAndDelete(commentId);

            return { message: 'Xóa bình luận thành công' };
        } catch (error) {
            throw error;
        }
    }

    static async getRatingStatsAndComments(req, res) {
        try {
            const { productId } = req.params;

            // Tìm tất cả bình luận của productId và active = true
            const comments = await commentModel.find({ productId, active: true })
                .sort({ createdAt: -1 }) // Sắp xếp theo thời gian tạo giảm dần
                .exec();

            if (!comments || comments.length === 0) {
                return {
                    message: 'Không có bình luận nào cho sản phẩm này',
                    ratingStats: {
                        1: 0,
                        2: 0,
                        3: 0,
                        4: 0,
                        5: 0
                    },
                    averageRating: 0,
                    comments: []
                };
            }

            // Thống kê số lượt rating từ 1 đến 5
            const ratingStats = {
                1: 0,
                2: 0,
                3: 0,
                4: 0,
                5: 0
            };

            let totalRating = 0;
            let ratingCount = comments.length;

            comments.forEach(comment => {
                const rating = comment.rating;
                if (rating >= 1 && rating <= 5) {
                    ratingStats[rating]++;
                    totalRating += rating;
                }
            });

            // Tính trung bình cộng rating
            const averageRating = ratingCount > 0 ? (totalRating / ratingCount).toFixed(2) : 0;

            // Trả về kết quả
            return {
                ratingStats,
                averageRating: parseFloat(averageRating),
                comments: comments.map(comment => ({
                    _id: comment._id,
                    productId: comment.productId,
                    userId: comment.userId,
                    comment: comment.comment,
                    rating: comment.rating,
                    images: comment.image || [],
                    createdAt: comment.createdAt,
                    updatedAt: comment.updatedAt
                }))
            };
        } catch (error) {
            throw error;
        }
    }

    static async getUserById(req, res) {
        try {
            const { userId } = req.params;
            console.log(`Fetching user by ID: ${userId}`);

            const user = await userModel.findOne({ userId }).select('profilePic fullName');

            return user;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = CommentService;