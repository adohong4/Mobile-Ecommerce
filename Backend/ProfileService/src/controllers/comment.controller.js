'use strict';

const CommentService = require('../services/comment.service');
const { CREATED, OK } = require('../core/success.response');

class CommentController {
    async commentProduct(req, res, next) {
        try {
            const result = await CommentService.commentProduct(req, res);
            new CREATED({
                message: 'Đánh giá sản phẩm thành công',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async getCommentProduct(req, res, next) {
        try {
            const result = await CommentService.getCommentProduct(req, res);
            new OK({
                message: 'get Comment Product',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async getCommentByUser(req, res, next) {
        try {
            const result = await CommentService.getCommentByUser(req, res);
            new OK({
                message: 'get Comment By User',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async deleteComment(req, res, next) {
        try {
            const result = await CommentService.deleteComment(req, res);
            new OK({
                message: 'delete Comment',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async getRatingStatsAndComments(req, res, next) {
        try {
            const result = await CommentService.getRatingStatsAndComments(req, res);
            new OK({
                message: 'get info',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    async getUserById(req, res, next) {
        try {
            const result = await CommentService.getUserById(req, res);
            new OK({
                message: 'get info',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

}

module.exports = new CommentController();