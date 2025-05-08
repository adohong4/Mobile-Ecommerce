'use strict';

const voucherModel = require('../models/voucher.model');
const { BadRequestError } = require('../core/error.response');

class VoucherService {
    static async createVoucher(payload) {
        try {
            const {
                code,
                discountType,
                discountValue,
                minOrderValue,
                maxDiscountAmount,
                applicableProducts,
                applicableCategories,
                usageLimit,
                startDate,
                endDate
            } = payload;

            if (!code || !discountType || !discountValue || !startDate || !endDate) {
                throw new BadRequestError('Vui lòng cung cấp đầy đủ thông tin: mã phiếu, loại giảm giá, giá trị giảm giá, ngày bắt đầu, ngày kết thúc');
            }

            const existingVoucher = await voucherModel.findOne({ code });
            if (existingVoucher) {
                throw new BadRequestError('Mã phiếu giảm giá đã tồn tại');
            }

            const newVoucher = await voucherModel.create({
                code,
                discountType,
                discountValue,
                minOrderValue: minOrderValue || 0,
                maxDiscountAmount: maxDiscountAmount || 0,
                applicableProducts: applicableProducts || [],
                applicableCategories: applicableCategories || [],
                usageLimit: usageLimit || 0,
                startDate,
                endDate,
                active: true
            });

            return newVoucher;
        } catch (error) {
            throw error;
        }
    }

    static async getVoucherList() {
        try {
            const voucher = await voucherModel.find()
                .sort({ createdAt: -1 })
                .exec();
            return voucher;
        } catch (error) {
            throw error;
        }
    }

    static async paginateVoucherList({ limit = 10, page = 1, active }) {
        try {
            const skip = (page - 1) * limit;
            const query = {};

            if (active !== undefined) {
                query.active = active;
            }

            const vouchers = await voucherModel
                .find(query)
                .skip(skip)
                .limit(limit)
                .sort({ createdAt: -1 })
                .lean();

            const total = await voucherModel.countDocuments(query);

            return {
                vouchers,
                total,
                page,
                limit,
                totalPages: Math.ceil(total / limit)
            };
        } catch (error) {
            throw error;
        }
    }

    static async softDeleteVoucher(req, res) {
        try {
            const { voucherId } = req.params;
            if (!voucherId) {
                throw new BadRequestError('Vui lòng cung cấp ID phiếu giảm giá');
            }

            const voucher = await voucherModel.findById(voucherId);
            if (!voucher) {
                throw new BadRequestError('Không tìm thấy phiếu giảm giá');
            }

            if (!voucher.active) {
                throw new BadRequestError('Phiếu giảm giá đã bị vô hiệu hóa');
            }

            const updatedVoucher = await voucherModel.findByIdAndUpdate(
                voucherId,
                { active: false },
                { new: true }
            );

            return updatedVoucher;
        } catch (error) {
            throw error;
        }
    }

    static async deleteVoucher(req, res) {
        try {
            const { voucherId } = req.params;
            if (!voucherId) {
                throw new BadRequestError('Vui lòng cung cấp ID phiếu giảm giá');
            }

            const voucher = await voucherModel.findById(voucherId);
            if (!voucher) {
                throw new BadRequestError('Không tìm thấy phiếu giảm giá');
            }

            await voucherModel.findByIdAndDelete(voucherId);

            return { message: 'Phiếu giảm giá đã được xóa thành công' };
        } catch (error) {
            throw error;
        }
    }

    static async updateVoucher(voucherId, payload) {
        try {
            if (!voucherId) {
                throw new BadRequestError('Vui lòng cung cấp ID phiếu giảm giá');
            }

            const {
                code,
                description,
                discountType,
                discountValue,
                minOrderValue,
                maxDiscountAmount,
                applicableProducts,
                applicableCategories,
                usageLimit,
                startDate,
                endDate,
                active
            } = payload;

            if (code) {
                const existingVoucher = await voucherModel.findOne({ code, _id: { $ne: voucherId } });
                if (existingVoucher) {
                    throw new BadRequestError('Mã phiếu giảm giá đã tồn tại');
                }
            }

            const voucher = await voucherModel.findById(voucherId);
            if (!voucher) {
                throw new BadRequestError('Không tìm thấy phiếu giảm giá');
            }

            if (code) voucher.code = code;
            if (description !== undefined) voucher.description = description;
            if (discountType) voucher.discountType = discountType;
            if (discountValue !== undefined) voucher.discountValue = discountValue;
            if (minOrderValue !== undefined) voucher.minOrderValue = minOrderValue;
            if (maxDiscountAmount !== undefined) voucher.maxDiscountAmount = maxDiscountAmount;
            if (applicableProducts) voucher.applicableProducts = applicableProducts;
            if (applicableCategories) voucher.applicableCategories = applicableCategories;
            if (usageLimit !== undefined) voucher.usageLimit = usageLimit;
            if (startDate) voucher.startDate = startDate;
            if (endDate) voucher.endDate = endDate;
            if (active !== undefined) voucher.active = active;

            const updatedVoucher = await voucher.save();

            return updatedVoucher;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = VoucherService;