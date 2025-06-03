'use strict';

const ProductService = require('../services/product.service');
const { CREATED, OK } = require('../core/success.response');

class ProductController {
    async createProduct(req, res, next) {
        try {
            const result = await ProductService.createProduct(req, res)
            new CREATED({
                message: 'create product',
                metadata: result.product
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async getProduct(req, res, next) {
        try {
            const result = await ProductService.getProduct(req, res)
            new OK({
                message: 'get product',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async getProductById(req, res, next) {
        try {
            const result = await ProductService.getProductById(req, res)
            new OK({
                message: 'get product by id',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async getProductByslug(req, res, next) {
        try {
            const result = await ProductService.getProductByslug(req, res)
            new OK({
                message: 'get product by slug',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async updateProduct(req, res, next) {
        try {
            const result = await ProductService.updateProduct(req, res)
            new CREATED({
                message: 'update product',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async deleteProduct(req, res, next) {
        try {
            const result = await ProductService.deleteProduct(req, res)
            new OK({
                message: 'delete product',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async softRestoreProduct(req, res, next) {
        try {
            const result = await ProductService.softRestoreProduct(req, res)
            new OK({
                message: 'soft delete product',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async getProductByName(req, res, next) {
        try {
            const result = await ProductService.getProductByName(req, res)
            new OK({
                message: 'get product by name',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async getProductByCategory(req, res, next) {
        try {
            const result = await ProductService.getProductByCategory(req, res)
            new OK({
                message: 'get Product By Category',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async getProductsByPage(req, res, next) {
        try {
            const result = await ProductService.getProductsByPage(req, res)
            new OK({
                message: 'get product by page',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async paginateProductTrash(req, res, next) {
        try {
            const result = await ProductService.paginateProductTrash(req, res)
            new OK({
                message: 'get product trash',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async updateQuantityProduct(req, res, next) {
        try {
            const result = await ProductService.updateQuantityProduct(req, res)
            new CREATED({
                message: 'update quantity product',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }
}

module.exports = new ProductController();