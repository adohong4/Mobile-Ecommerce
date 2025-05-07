'use strict';

const CartService = require('../services/cart.service');
const { OK, CREATED } = require('../core/success.response');

class CartController {
    addToCart = async (req, res) => {
        const cartData = await CartService.addToCart(req, res);
        new CREATED({
            message: 'Add to cart',
            metadata: cartData
        }).send(res);
    };

    getListCart = async (req, res) => {
        const cartData = await CartService.getListCart(req, res);
        new OK({
            message: 'Get list cart',
            metadata: cartData
        }).send(res);
    };

    removeFromCart = async (req, res) => {
        const cartData = await CartService.removeFromCart(req, res);
        new OK({
            message: 'Remove from cart',
            metadata: cartData
        }).send(res);
    };
}

module.exports = new CartController();