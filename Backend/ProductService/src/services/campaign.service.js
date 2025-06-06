'use strict';

const campaignModel = require('../models/campaign.model')
const { BadRequestError, ConflictRequestError, AuthFailureError } = require('../core/error.response');

class CampaignService {
    static createCampaign = async (req, res) => {
        try {
            const {
                name,
                description,
                value,
                code,
                startDate,
                endDate,
                status: inputStatus,
                maxValue,
                appliesTo,
                productIds,
                type,
            } = req.body;

            // Kiểm tra type
            if (type === 'percentage') {
                if (value <= 0 || value > 100) {
                    throw new BadRequestError('Giá trị giảm phần trăm phải lớn hơn 0 và nhỏ hơn hoặc bằng 100');
                }
            } else if (type === 'fixed_amount') {
                if (value <= 0) {
                    throw new BadRequestError('Giá trị giảm cố định phải lớn hơn 0');
                }
            } else {
                throw new BadRequestError('Loại khuyến mãi không hợp lệ');
            }

            // Kiểm tra thời gian
            const now = new Date();
            if (now > new Date(endDate)) {
                throw new BadRequestError('Chiến dịch đã hết hạn');
            }
            if (new Date(startDate) >= new Date(endDate)) {
                throw new BadRequestError('Ngày bắt đầu phải trước ngày kết thúc');
            }

            // Kiểm tra mã code
            const foundCampaign = await campaignModel.findOne({ code });
            if (foundCampaign && foundCampaign.active) {
                throw new ConflictRequestError('Mã khuyến mãi đã tồn tại và đang hoạt động');
            }

            // Xác định trạng thái chiến dịch
            let campaignStatus = inputStatus || 'pending';
            if (new Date(startDate) <= now && now <= new Date(endDate)) {
                campaignStatus = 'active';
            } else if (new Date(startDate) > now) {
                campaignStatus = 'pending';
            }

            // Kiểm tra appliesTo và productIds
            if (appliesTo === 'items' && (!productIds || productIds.length === 0)) {
                throw new BadRequestError('Vui lòng chọn ít nhất một sản phẩm áp dụng');
            }
            if (appliesTo === 'all') {
                productIds = [];
            }

            // Nếu type là fixed_amount, đặt maxValue về null
            const finalMaxValue = type === 'fixed_amount' ? null : maxValue;

            const newCampaign = await campaignModel.create({
                name,
                description,
                value,
                code,
                startDate,
                endDate,
                status: campaignStatus,
                maxValue: finalMaxValue,
                appliesTo,
                productIds: productIds || [],
                type,
            });

            return {
                metadata: newCampaign,
            };
        } catch (error) {
            throw new BadRequestError(error.message || 'Lỗi khi tạo chiến dịch');
        }
    };

    static getAllCampaign = async () => {
        const campaign = await campaignModel.find()
            .select('name description value code startDate endDate status maxValue appliesTo productIds active type')
            .sort({ createdAt: -1 })
            .exec();
        return { metadata: campaign }
    }

    static getCampaignById = async (req, res) => {
        const { id } = req.params;
        const campaign = await campaignModel.findById(id);
        return { metadata: campaign }
    }

    static updateCampaignById = async (req, res) => {
        try {
            const { id } = req.params;
            const { name, description, value, code, startDate, endDate, status, maxValue, appliesTo, productIds, type } = req.body
            const updates = { name, description, value, code, startDate, endDate, status, maxValue, appliesTo, productIds, type };

            // Kiểm tra điều kiện của type
            if (type === 'percentage' && (value <= 0 || value > 100)) {
                throw new BadRequestError('Value must be greater than 0 and less than or equal to 100 for percentage type');
            }
            if (type === 'fixed_amount' && value <= 0) {
                throw new BadRequestError('Value must be greater than 0 for fixed amount type');
            }
            // Kiểm tra thời gian
            const now = new Date();

            //Kiểm tra trạng thái
            if (status === 'active') {
                if (now < new Date(startDate) || now > new Date(endDate)) {
                    throw new BadRequestError('Trạng thái "Hoạt động" không phù hợp với thời gian chiến dịch.');
                }
            }

            // if (now > new Date(endDate)) throw new BadRequestError('Discount codes has expired');
            if (new Date(startDate) >= new Date(endDate)) throw new BadRequestError('Start_Date must be before End_date');

            // Kiểm tra CODE
            const foundCampaign = await campaignModel.findOne({ code, _id: { $ne: id } });
            if (foundCampaign && foundCampaign.active) throw new BadRequestError('CODE exist!');

            /// Cập nhật appliesTo và productIds
            if (appliesTo === 'all') {
                updates.productIds = [];
            } else if (appliesTo === 'items' && (!productIds || productIds.length === 0)) {
                throw new BadRequestError('Vui lòng chọn sản phẩm áp dụng khuyến mãi');
            }

            if (type === 'fixed_amount') {
                updates.maxValue = null;
            }

            // Xóa các trường không có giá trị
            Object.keys(updates).forEach(key => updates[key] === undefined && delete updates[key]);

            // Cập nhật thông tin chiến dịch trong database
            const updatedCampaign = await campaignModel.findByIdAndUpdate(id, updates, { new: true });

            // Kiểm tra xem updatedCampaign có tồn tại không
            if (!updatedCampaign) {
                throw new BadRequestError('Campaign not found');
            }

            await updatedCampaign.save();

            return { metadata: updatedCampaign };
        } catch (error) {
            throw error;
        }
    }

    static activeCampaign = async (req, res) => {
        try {
            const { id } = req.params;
            const campaign = await campaignModel.findById(id)
            const newActiveStatus = !campaign.active;
            const actionDescription = newActiveStatus ? "Phục hồi chiến dịch" : "Xóa chiến dịch";

            campaign.active = newActiveStatus;
            await campaign.save();

            return { metadata: campaign }
        } catch (error) {
            throw error;
        }
    }

    static deleteCampaign = async (req, res) => {
        try {
            const { id } = req.params;
            await campaignModel.findByIdAndDelete(id)
            return;
        } catch (error) {
            throw error;
        }
    }

}

module.exports = CampaignService;