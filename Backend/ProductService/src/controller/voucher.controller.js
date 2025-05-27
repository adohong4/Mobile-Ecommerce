'use strict';

const VoucherService = require('../services/voucher.service');
const { OK, CREATED } = require('../core/success.response');

class VoucherController {
    async createVoucher(req, res, next) {
        try {
            const result = await VoucherService.createVoucher(req.body);
            new CREATED({
                message: 'Tạo phiếu giảm giá thành công',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async getVoucherList(req, res, next) {
        try {
            const result = await VoucherService.getVoucherList();
            new OK({
                message: 'Lấy phiếu giảm giá thành công',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async getVoucherById(req, res, next) {
        try {
            const result = await VoucherService.getVoucherById(req, res);
            new OK({
                message: 'Lấy phiếu giảm giá thành công',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async paginateVoucherList(req, res, next) {
        try {
            const { limit, page, active } = req.query;
            const result = await VoucherService.paginateVoucherList({
                limit: parseInt(limit) || 10,
                page: parseInt(page) || 1,
                active: active !== undefined ? active === 'true' : undefined
            });
            new OK({
                message: 'Lấy danh sách phiếu giảm giá thành công',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async softDeleteVoucher(req, res, next) {
        try {
            const result = await VoucherService.softDeleteVoucher(req, res);
            new OK({
                message: 'Vô hiệu hóa phiếu giảm giá thành công',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async deleteVoucher(req, res, next) {
        try {
            const result = await VoucherService.deleteVoucher(req, res);
            new OK({
                message: 'Xóa phiếu giảm giá thành công',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async updateVoucher(req, res, next) {
        try {
            const { voucherId } = req.params;
            const result = await VoucherService.updateVoucher(voucherId, req.body);
            new OK({
                message: 'Cập nhật phiếu giảm giá thành công',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async useVoucher(req, res, next) {
        try {
            const result = await VoucherService.useVoucher(req, res);
            new OK({
                message: 'Áp phiếu giảm giá thành công',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }
}

module.exports = new VoucherController();