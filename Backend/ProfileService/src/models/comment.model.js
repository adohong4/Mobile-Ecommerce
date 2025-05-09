'use strict';

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const DOCUMENT_NAME = 'Comments';

const CommentSchema = new Schema({
    productId: {
        type: Object,
        required: [true, 'Vui lòng cung cấp ID sản phẩm'],
    },
    userId: {
        type: Object,
        required: [true, 'Vui lòng cung cấp ID người dùng'],
    },
    image: [String],
    comment: {
        type: String,
        required: [true, 'Nội dung bình luận không được để trống'],
        trim: true,
        minlength: [1, 'Nội dung bình luận không được để trống'],
        maxlength: [1000, 'Nội dung bình luận không được vượt quá 1000 ký tự']
    },
    rating: {
        type: Number,
        required: [true, 'Vui lòng cung cấp đánh giá'],
        min: [1, 'Đánh giá phải từ 1 đến 5'],
        max: [5, 'Đánh giá phải từ 1 đến 5'],
        validate: {
            validator: Number.isInteger,
            message: 'Đánh giá phải là số nguyên'
        }
    },
    active: { type: Boolean, default: true }
}, { minimize: false, timestamps: true });

// CommentSchema.index({ productId: 1, createdAt: -1 });
// CommentSchema.index({ userId: 1 });

CommentSchema.pre('save', function (next) {
    if (this.isModified('replies')) {
        this.replies.forEach(reply => {
            if (!reply.updatedAt) {
                reply.updatedAt = new Date();
            }
        });
    }
    next();
});

const commentModel = mongoose.models.comment || mongoose.model(DOCUMENT_NAME, CommentSchema);

module.exports = commentModel;