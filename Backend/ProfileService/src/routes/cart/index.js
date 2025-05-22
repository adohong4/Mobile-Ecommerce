'use strict'

const express = require('express');
const { asyncHandler } = require('../../helpers/asyncHandler');
const CartController = require('../../controllers/cart.controller');
const { checkTokenCookie, checkTokenHeader } = require('../../middleware/checkAuth');
const router = express.Router();

router.post('/cart/add', checkTokenHeader, asyncHandler(CartController.addToCart));
router.get('/cart/list', checkTokenHeader, asyncHandler(CartController.getListCart));
router.post('/cart/remove', checkTokenHeader, asyncHandler(CartController.removeFromCart));

router.get('/order/list', checkTokenHeader, asyncHandler(CartController.orderData));

module.exports = router;