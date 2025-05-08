'use strict';

const FavouriteService = require('../services/favourite.service');
const { OK, CREATED } = require('../core/success.response');

class FavouriteController {
    async addToFavourite(req, res, next) {
        try {
            const result = await FavouriteService.addToFavourite(req, res);
            new CREATED({
                message: 'add to favorite',
                metadata: result,
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async removeFromFavourite(req, res, next) {
        try {
            const result = await FavouriteService.removeFromFavourite(req, res);
            new CREATED({
                message: 'remove from favorite',
                metadata: result,
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async getListFavourite(req, res, next) {
        try {
            const result = await FavouriteService.getListFavourite(req, res);
            new OK({
                message: 'Get list favorite',
                metadata: result,
            }).send(res);
        } catch (error) {
            next(error);
        }
    }
}

module.exports = new FavouriteController();