'use strict';

const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const DOCUMENT_NAME = 'Vouchers';

const VoucherSchema = new Schema(
    {
        code: {
            type: String,
            required: true,
            unique: true,
            uppercase: true,
            trim: true,
            match: [/^[A-Z0-9]{6,12}$/, 'Mã phiếu giảm giá phải dài 6-12 ký tự và chỉ chứa chữ cái in hoa hoặc số']
        },
        discountType: {
            type: String,
            enum: ['PERCENTAGE', 'FIXED_AMOUNT'],
            required: true,
        },
        discountValue: {
            type: Number,
            required: true,
            min: [0, 'Giá trị giảm giá không được âm'],
            validate: {
                validator: function (value) {
                    if (this.discountType === 'PERCENTAGE') {
                        return value <= 100;
                    }
                    return true;
                },
                message: 'Giá trị phần trăm giảm giá không được vượt quá 100%'
            }
        },
        minOrderValue: {
            type: Number,
            default: 0,
            min: [0, 'Giá trị đơn hàng tối thiểu không được âm'],
        },
        maxDiscountAmount: {
            type: Number,
            default: 0,
            min: [0, 'Số tiền giảm tối đa không được âm'],
        },
        applicableProducts: { type: Array, default: [] },
        applicableCategories: { type: Array, default: [] },
        usageLimit: {
            type: Number,
            default: 0,
            min: [0, 'Giới hạn sử dụng không được âm'],
        },
        usedCount: {
            type: Number,
            default: 0,
            min: [0, 'Số lần đã sử dụng không được âm'],
        },
        userUsed: { type: Array, default: [] },
        startDate: { type: Date, required: true, },
        endDate: {
            type: Date,
            required: true,
            validate: {
                validator: function (value) {
                    return value > this.startDate;
                },
                message: 'Ngày kết thúc phải sau ngày bắt đầu'
            }
        },
        active: { type: Boolean, default: true, },
    },
    { minimize: false, timestamps: true }
);

VoucherSchema.pre('save', function (next) {
    const now = new Date();
    if (this.endDate < now) {
        this.isActive = false;
    }
    next();
});

const voucherModel = mongoose.models.voucher || mongoose.model(DOCUMENT_NAME, VoucherSchema);

module.exports = voucherModel;