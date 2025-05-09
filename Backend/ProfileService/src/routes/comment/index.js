'use strict'

const express = require('express');
const { asyncHandler } = require('../../helpers/asyncHandler');
const commentController = require('../../controllers/comment.controller');
const { checkTokenCookie } = require('../../middleware/checkAuth');
const router = express.Router();

router.post('/profile/comment', checkTokenCookie, asyncHandler(commentController.commentProduct));
router.get('/profile/comment/product/get', checkTokenCookie, asyncHandler(commentController.getCommentProduct));
router.get('/profile/comment/user/get', checkTokenCookie, asyncHandler(commentController.getCommentByUser));
router.delete('/profile/comment/user/delete/:commentId', checkTokenCookie, asyncHandler(commentController.deleteComment));

module.exports = router;