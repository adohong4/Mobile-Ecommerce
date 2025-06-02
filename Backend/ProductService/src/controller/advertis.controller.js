'use strict';

const AdvertiseService = require('../services/advertise.service');
const { OK, CREATED } = require('../core/success.response');

class AdvertiseController {
    async createAdvertise(req, res, next) {
        try {
            const result = await AdvertiseService.createAdvertise(req, res);
            new CREATED({
                message: 'create Advertise',
                metadata: result
            }).send(res);
        } catch (error) {
            throw error;
        }
    }

    async getAdvertise(req, res, next) {
        try {
            const result = await AdvertiseService.getAdvertise(req, res);
            new CREATED({
                message: 'get Advertis',
                metadata: result
            }).send(res);
        } catch (error) {
            throw error;
        }
    }

    async deleteAdvertise(req, res, next) {
        try {
            const result = await AdvertiseService.deleteAdvertise(req, res);
            new CREATED({
                message: 'delete Advertis',
                metadata: result
            }).send(res);
        } catch (error) {
            throw error;
        }
    }

    async activeAdvertise(req, res, next) {
        try {
            const result = await AdvertiseService.activeAdvertise(req, res);
            new CREATED({
                message: 'active Advertise',
                metadata: result
            }).send(res);
        } catch (error) {
            throw error;
        }
    }

    async getBannerActive(req, res, next) {
        try {
            const result = await AdvertiseService.getBannerActive();
            new CREATED({
                message: 'get Banner',
                metadata: result
            }).send(res);
        } catch (error) {
            throw error;
        }
    }

    async getAdvertiseActive(req, res, next) {
        try {
            const result = await AdvertiseService.getAdvertiseActive();
            new CREATED({
                message: 'get Advertise',
                metadata: result
            }).send(res);
        } catch (error) {
            throw error;
        }
    }
}

module.exports = new AdvertiseController();