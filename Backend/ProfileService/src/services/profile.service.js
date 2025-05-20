'use strict';

const profileModel = require('../models/profile.model');
const cloudinary = require('../config/cloudinary.config');
const { BadRequestError, ConflictRequestError, AuthFailureError, ForbiddenError } = require("../core/error.response")

class ProfileService {
    static async getProfile(req, res) {
        try {
            const userId = req.user._id;
            console.log("userid: ", userId)
            const profile = await profileModel.find({ userId });
            return profile;
        } catch (error) {
            throw error;
        }
    }

    static async updateInfoProfile(req, res) {
        try {
            const userId = req.user._id;
            const { fullName, gender, dateOfBirth, phoneNumber } = req.body;

            const updateInfoProfile = { userId, fullName, gender, dateOfBirth, phoneNumber };

            Object.keys(updateInfoProfile).forEach(key => updateInfoProfile[key] === undefined && delete updateInfoProfile[key]);

            const existingProfile = await profileModel.findOne({ userId });
            let updatedProfile;

            if (!existingProfile) {
                updatedProfile = await profileModel.create({
                    userId,
                    fullName,
                    gender,
                    dateOfBirth,
                    phoneNumber,
                    address: [],
                    cartData: {}
                });
            } else {
                updatedProfile = await profileModel.findOneAndUpdate(
                    { userId },
                    { $set: updateInfoProfile },
                    { new: true, runValidators: true }
                );
            }

            return updatedProfile;
        } catch (error) {
            throw error;
        }
    }

    static async updateProfilePic(req, res) {
        try {
            const userId = req.user._id;

            const existProfile = await profileModel.findOne({ userId });
            if (!existProfile) {
                throw new BadRequestError('Cần cập nhật thông tin tài khoản');
            }

            let image_filename = "";
            if (req.file) {
                image_filename = req.file.path;
            } else {
                throw new Error("No file uploaded");
            }

            const uploadResponse = await cloudinary.uploader.upload(image_filename, {
                resource_type: 'auto'
            });

            const updatedProfile = await profileModel.findOneAndUpdate(
                { userId },
                { profilePic: uploadResponse.secure_url },
                { new: true, runValidators: true }
            )

            return updatedProfile;
        } catch (error) {
            throw error;
        }
    }

}

module.exports = ProfileService;