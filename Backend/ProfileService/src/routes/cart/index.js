'use strict'

const express = require('express');
const { asyncHandler } = require('../../helpers/asyncHandler');
const CartController = require('../../controllers/cart.controller');
const { checkTokenCookie } = require('../../middleware/checkAuth');
const router = express.Router();

router.get('/cart/add', checkTokenCookie, asyncHandler(CartController.addToCart));
router.post('/cart/list', checkTokenCookie, asyncHandler(CartController.getListCart));
router.post('/cart/remove', checkTokenCookie, asyncHandler(CartController.removeFromCart));

module.exports = router;