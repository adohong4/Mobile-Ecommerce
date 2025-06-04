'use strict';

const viewedProductService = require('../services/viewedProduct.service');
const { OK, CREATED } = require('../core/success.response');

class ViewedProductController {
    async getViewedProducts(req, res, next) {
        try {
            const result = await viewedProductService.getViewedProducts(req, res);
            new OK({
                message: 'Viewed products retrieved successfully',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async addViewedProduct(req, res, next) {
        try {
            const result = await viewedProductService.addViewedProduct(req, res);
            new CREATED({
                message: 'Product added to viewed list successfully',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }
}

module.exports = new ViewedProductController();