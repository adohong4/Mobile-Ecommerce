'use strict'

const profileModel = require("../models/profile.model");
const { BadRequestError } = require("../core/error.response");

class AddressService {
    static async createAddress(req, res) {
        try {
            const userId = req.user._id;

            const existingProfile = await profileModel.findOne({ userId });
            if (!existingProfile) {
                throw new BadRequestError("Cần cập nhật thông tin tài khoản");
            }
            const { fullname, phone, street, precinct, city, province } = req.body;
            const newAddress = { fullname, phone, street, precinct, city, province };

            const updatedProfile = await profileModel.findOneAndUpdate(
                { userId },
                { $push: { address: newAddress } },
                { new: true, runValidators: true }
            );

            return updatedProfile.address;
        } catch (error) {
            throw error;
        }
    }

    static async getListAddress(req, res) {
        try {
            const userId = req.user._id;
            const profile = await profileModel.findOne({ userId });
            if (!profile) {
                throw new BadRequestError("Tài khoản không tồn tại");
            }

            return { metadata: { address: profile.address } };
        } catch (error) {
            throw error;
        }
    }

    static deleteAddress = async (req, res) => {
        try {
            const userId = req.user._id;
            const { addressId } = req.params;
            const profile = await profileModel.findOne({ userId });

            if (!profile) {
                throw new BadRequestError("Tài khoản không tồn tại");
            }

            const updatedProfile = await profileModel.findOneAndUpdate(
                { userId },
                { $pull: { address: { _id: addressId } } },
                { new: true }
            );

            if (!updatedProfile) {
                throw new BadRequestError("Không tìm thấy địa chỉ để xóa");
            }

            return;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = AddressService;