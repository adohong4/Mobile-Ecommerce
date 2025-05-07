'use strict';

const CategoryService = require('../services/category.service');
const { OK, CREATED } = require('../core/success.response');

class CategoryController {
    async createCategory(req, res, next) {
        try {
            const result = await CategoryService.createCategory(req, res)
            new CREATED({
                message: 'create category',
                metadata: result.newCategory
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async getCategoryList(req, res, next) {
        try {
            const result = await CategoryService.getCategoryList(req, res)
            new CREATED({
                message: 'get category',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async getCategoryById(req, res, next) {
        try {
            const result = await CategoryService.getCategoryById(req, res)
            new CREATED({
                message: 'get category',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async softDeleteCategory(req, res, next) {
        try {
            const result = await CategoryService.softDeleteCategory(req, res)
            new CREATED({
                message: 'soft delete category',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async deleteCategory(req, res, next) {
        try {
            const result = await CategoryService.deleteCategory(req, res)
            new CREATED({
                message: 'delete category',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }
}

module.exports = new CategoryController();