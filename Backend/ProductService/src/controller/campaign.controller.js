'use strict';

const CampaignService = require('../services/campaign.service')
const CustomCampaignService = require('../services/campaign.custom')
const { OK, CREATED, SuccessResponse } = require('../core/success.response')

class CampaignController {

    createCampaign = async (req, res, next) => {
        try {
            const result = await CampaignService.createCampaign(req, res)
            new CREATED({
                message: 'Tạo chiến dịch thành công',
                metadata: result.metadata
            }).send(res)
        } catch (error) {
            next(error);
        }
    }

    getAllCampaign = async (req, res, next) => {
        const result = await CampaignService.getAllCampaign()
        new OK({
            message: 'Lấy danh sách thành công',
            metadata: result.metadata
        }).send(res)
    }

    getCampaignById = async (req, res, next) => {
        const result = await CampaignService.getCampaignById(req, res)
        new OK({
            message: 'Lấy danh sách thành công',
            metadata: result.metadata
        }).send(res)
    }

    updateCampaignById = async (req, res, next) => {
        const result = await CampaignService.updateCampaignById(req, res);
        new CREATED({
            message: 'cập nhật thành công',
            metadata: result.metadata
        }).send(res)
    }

    activeCampaign = async (req, res, next) => {
        const result = await CampaignService.activeCampaign(req, res)
        new CREATED({
            message: 'chuyển đổi thành công',
            metadata: result.metadata
        }).send(res)
    }

    deleteCampaign = async (req, res, next) => {
        await CampaignService.deleteCampaign(req, res)
        new OK({
            message: 'Xóa thành công',
        }).send(res)
    }

    paginateCampaign = async (req, res, next) => {
        try {
            const result = await CustomCampaignService.paginateCampaign(req, res)
            new CREATED({
                message: 'phân trang thành công',
                metadata: result.metadata
            }).send(res)
        } catch (error) {
            next(error);
        }
    }

    paginateCampaignTrash = async (req, res, next) => {
        try {
            const result = await CustomCampaignService.paginateCampaignTrash(req, res)
            new CREATED({
                message: 'phân trang thành công',
                metadata: result.metadata
            }).send(res)
        } catch (error) {
            next(error);
        }
    }

    searchCampaignByCode = async (req, res, next) => {
        try {
            const result = await CustomCampaignService.searchCampaignByCode(req, res)
            new CREATED({
                message: 'lấy thông tin thành công',
                metadata: result.metadata
            }).send(res)
        } catch (error) {
            next(error);
        }
    }

    addToCampaign = async (req, res, next) => {
        const result = await CustomCampaignService.addToCampaign(req, res)
        new CREATED({
            message: 'Thêm id sản phẩm vào phiếu giảm giá thành công',
            metadata: result.metadata
        }).send(res)
    }

    removeFromCampaign = async (req, res, next) => {
        const result = await CustomCampaignService.removeFromCampaign(req, res)
        new CREATED({
            message: 'Xóa id sản phẩm vào phiếu giảm giá thành công',
            metadata: result.metadata
        }).send(res)
    }

    updateProductPricesForCampaign = async (req, res, next) => {
        const result = await CustomCampaignService.updateProductPricesForCampaign()
        new CREATED({
            message: 'Thông tin sản phẩm sau update',
            metadata: result.metadata
        }).send(res)
    }

    updateProductPricesForCampaignBySlug = async (req, res, next) => {
        const result = await CustomCampaignService.updateProductPricesForCampaignBySlug(req, res)
        new OK({
            message: 'Thông tin sản phẩm theo id sau update',
            metadata: result.metadata
        }).send(res)
    }
}

module.exports = new CampaignController();