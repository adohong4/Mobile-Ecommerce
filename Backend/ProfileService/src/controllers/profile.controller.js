'use strict';

const ProfileService = require('../services/profile.service');
const { OK, CREATED } = require('../core/success.response');

class ProfileController {
    getProfile = async (req, res, next) => {
        try {
            const result = await ProfileService.getProfile(req, res);
            new OK({
                message: 'Lấy thông tin',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    };

    updateInfoProfile = async (req, res, next) => {
        try {
            const result = await ProfileService.updateInfoProfile(req, res);
            new CREATED({
                message: 'Cập nhật thông tin',
                matedata: result,
            }).send(res);
        } catch (error) {
            next(error);
        }
    };

    updateProfilePic = async (req, res, next) => {
        try {
            const result = await ProfileService.updateProfilePic(req, res);
            new OK({
                message: 'Cập nhật ảnh đại diện',
                matedata: result,
            }).send(res);
        } catch (error) {
            next(error);
        }
    };
}

module.exports = new ProfileController();