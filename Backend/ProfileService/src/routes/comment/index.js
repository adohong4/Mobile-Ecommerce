'use strict'

const express = require('express');
const { asyncHandler } = require('../../helpers/asyncHandler');
const commentController = require('../../controllers/comment.controller');
const { checkTokenCookie, checkTokenHeader } = require('../../middleware/checkAuth');
const router = express.Router();

router.post('/profile/comment', checkTokenHeader, asyncHandler(commentController.commentProduct));
router.get('/profile/comment/product/get/:productId', asyncHandler(commentController.getCommentProduct));
router.get('/profile/comment/user/get', checkTokenHeader, asyncHandler(commentController.getCommentByUser));
router.delete('/profile/comment/user/delete/:commentId', checkTokenHeader, asyncHandler(commentController.deleteComment));

router.get('/profile/comment/product/rate/:productId', asyncHandler(commentController.getAverageRatingByProduct));

module.exports = router;