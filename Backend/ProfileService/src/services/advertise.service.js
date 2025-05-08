'use strict';

const userAdsModel = require('../models/profile.model');
const { BadRequestError } = require('../core/error.response');

class UserAdsService {
    static async addToAds(req, res) {
        try {
            const userId = req.user._id;
            const { adsId } = req.body;

            const profile = await userAdsModel.findOne({ userId });

            if (profile.saveVoucher.includes(adsId)) {
                throw new BadRequestError('Sản phẩm đã có trong danh sách yêu thích');
            }

            profile.saveVoucher.push(adsId);

            const updatedProfile = await userAdsModel.findOneAndUpdate(
                { userId },
                { saveVoucher: profile.saveVoucher },
                { new: true }
            );

            return updatedProfile.saveVoucher;
        } catch (error) {
            throw error;
        }
    }

    static async getUserAdsList(req, res) {
        try {
            const userId = req.user._id;
            const profile = await userAdsModel.findOne({ userId });

            return profile.saveVoucher;
        } catch (error) {
            throw error;
        }
    }

    static async removeFromAds(req, res) {
        try {
            const userId = req.user._id;
            const { adsId } = req.body;

            const profile = await userAdsModel.findOne({ userId });

            profile.saveVoucher = profile.saveVoucher.filter(id => id.toString() !== adsId.toString());

            const updatedProfile = await userAdsModel.findOneAndUpdate(
                { userId },
                { saveVoucher: profile.saveVoucher },
                { new: true }
            );

            return updatedProfile.saveVoucher;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = UserAdsService;