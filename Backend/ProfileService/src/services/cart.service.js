'use strict';

const userCartModel = require('../models/identity.model');
const { BadRequestError } = require('../core/error.response');

class CartService {
    static async addToCart(req, res) {
        try {
            const userId = req.user._id;
            let user = await userCartModel.findOne({ userId });

            let cartData = await user.cartData;
            if (!cartData[itemId]) {
                cartData[itemId] = 1;
            } else {
                cartData[itemId] += 1;
            }
            const upadateCart = await userCartModel.findByIdAndUpdate({ userId }, { cartData });
            return upadateCart.cartData;
        } catch (error) {
            throw error;
        }
    }

    static async getListCart(req, res) {
        try {
            const userId = req.user._id;
            const cart = await userCartModel.findOne({ userId });
            return cart.cartData;
        } catch (error) {
            throw error;
        }
    }

    static async removeFromCart(req, res) {
        try {
            const userId = req.user._id;
            const { itemId } = req.params;
            const profile = await userCartModel.findOne({ userId });

            let cartData = await profile.cartData;
            if (cartData[itemId]) {
                cartData[itemId] -= 1;
            }

            const updatedProfile = await userCartModel.findOneAndUpdate(
                { userId },
                { cartData },
                { new: true }
            );

            return updatedProfile.cartData;
        } catch (error) {
            throw error;
        }
    };
}

module.exports = CartService;
