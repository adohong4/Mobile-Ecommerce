'use strict';

const userFavouriteModel = require('../models/profile.model');
const { BadRequestError } = require('../core/error.response');

class FavouriteService {
    static async addToFavourite(req, res) {
        try {
            const userId = req.user._id;
            const { itemId } = req.body;

            const profile = await userFavouriteModel.findOne({ userId });

            if (profile.favourite.includes(itemId)) {
                throw new BadRequestError('Sản phẩm đã có trong danh sách yêu thích');
            }

            if (profile.favourite.length >= 20) {
                throw new BadRequestError('Danh sách yêu thích đã đạt tối đa 20 sản phẩm');
            }

            profile.favourite.push(itemId);

            const updatedProfile = await userFavouriteModel.findOneAndUpdate(
                { userId },
                { favourite: profile.favourite },
                { new: true }
            );

            return updatedProfile.favourite;
        } catch (error) {
            throw error;
        }
    }

    static async getListFavourite(req, res) {
        try {
            const userId = req.user._id;
            const profile = await userFavouriteModel.findOne({ userId });

            return profile.favourite;
        } catch (error) {
            throw error;
        }
    }

    static async removeFromFavourite(req, res) {
        try {
            const userId = req.user._id;
            const { itemId } = req.body;

            const profile = await userFavouriteModel.findOne({ userId });

            profile.favourite = profile.favourite.filter(id => id.toString() !== itemId.toString());

            const updatedProfile = await userFavouriteModel.findOneAndUpdate(
                { userId },
                { favourite: profile.favourite },
                { new: true }
            );

            return updatedProfile.favourite;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = FavouriteService;