'use strict';

const CartService = require('../services/cart.service');
const OrderService = require('../services/order.service');
const { OK, CREATED } = require('../core/success.response');

class CartController {
    addToCart = async (req, res, next) => {
        try {
            const cartData = await CartService.addToCart(req, res);
            new CREATED({
                message: 'Add to cart',
                metadata: cartData
            }).send(res);
        } catch (error) {
            next(error);
        }
    };

    getListCart = async (req, res, next) => {
        try {
            const cartData = await CartService.getListCart(req, res);
            new OK({
                message: 'Get list cart',
                metadata: cartData
            }).send(res);
        } catch (error) {
            next(error);
        }
    };

    removeFromCart = async (req, res, next) => {
        try {
            const cartData = await CartService.removeFromCart(req, res);
            new OK({
                message: 'Remove from cart',
                metadata: cartData
            }).send(res);
        } catch (error) {
            next(error);
        }
    };

    orderData = async (req, res, next) => {
        try {
            const orderData = await OrderService.orderData(req, res);
            new OK({
                message: 'Order data',
                metadata: orderData
            }).send(res);
        } catch (error) {
            next(error);
        }
    };
}

module.exports = new CartController();