'use strict';

const userCartModel = require('../models/identity.model');
const { BadRequestError } = require('../core/error.response');

class CartService {
    static async addToCart(req, res) {
        try {
            const userId = req.user._id;
            const { itemId } = req.body;
            let user = await userCartModel.findById(userId);
            let cartData = user.cartData || {};
            if (!cartData[itemId]) {
                cartData[itemId] = 1;
            } else {
                cartData[itemId] += 1;
            }
            const upadateCart = await userCartModel.findByIdAndUpdate(
                userId,
                { cartData: cartData },
                { new: true }
            );
            return upadateCart.cartData;
        } catch (error) {
            throw error;
        }
    }

    static async getListCart(req, res) {
        try {
            const userId = req.user._id;
            const cart = await userCartModel.findById(userId);
            return cart.cartData;
        } catch (error) {
            throw error;
        }
    }

    static async removeFromCart(req, res) {
        try {
            const userId = req.user._id;
            const { itemId } = req.body;
            const user = await userCartModel.findById(userId);

            let cartData = user.cartData || {};
            if (cartData[itemId] && cartData[itemId] > 0) {
                cartData[itemId] -= 1;
            }

            if (cartData[itemId] === 0) {
                delete cartData[itemId];
            }

            const updatedUser = await userCartModel.findByIdAndUpdate(
                userId,
                { cartData: cartData },
                { new: true }
            );

            return updatedUser.cartData;
        } catch (error) {
            throw error;
        }
    };
}

module.exports = CartService;
