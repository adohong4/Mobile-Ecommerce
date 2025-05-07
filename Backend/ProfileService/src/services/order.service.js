'use strict'

const { orderModel } = require('../models/order.model');
const { BadRequestError } = require('../core/error.response');

class OrderService {
    static async orderData(req, res) {
        try {
            const { userId } = req.user._id;
            const orderData = await orderModel.find({ userId })
                .select('userId amount status paymentMethod payment statusActive date items._id items.images items.title items.price items.quantity items.category items.product_slug')
                .sort({ createdAt: -1 })
                .exec();
            return orderData;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = OrderService;