'use strict'

const UserAdsService = require('../services/advertise.service');
const { OK, CREATED } = require('../core/success.response');

class UserAdsController {
    async addToAds(req, res, next) {
        try {
            const result = await UserAdsService.addToAds(req, res);
            new CREATED({
                message: 'save Ads',
                metadata: result,
            }).send(res);
        } catch (error) {
            next(error)
        }
    }

    async removeFromAds(req, res, next) {
        try {
            const result = await UserAdsService.removeFromAds(req, res);
            new OK({
                message: 'save Ads',
                metadata: result,
            }).send(res);
        } catch (error) {
            next(error)
        }
    }

    async getAds(req, res, next) {
        try {
            const result = await UserAdsService.getUserAdsList(req, res);
            new OK({
                message: 'save Ads',
                metadata: result,
            }).send(res);
        } catch (error) {
            next(error)
        }
    }
}

module.exports = new UserAdsController();