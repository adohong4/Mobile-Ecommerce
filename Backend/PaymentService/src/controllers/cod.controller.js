'use strict'

const userModel = require('../models/identity.model')
const orderModel = require('../models/order.model')
const { BadRequestError, ConflictRequestError, AuthFailureError, ForbiddenError } = require("../core/error.response")
const { CREATED } = require("../core/success.response")

class CODController {
    CODplaceOrder = async (req, res) => {
        const userId = req.user;
        console.log("userId", userId);
        try {
            const newOrder = new orderModel({
                userId: userId,
                items: req.body.items,
                amount: req.body.amount,
                address: req.body.address,
                paymentMethod: "cod"
            });

            await newOrder.save();
            await userModel.findByIdAndUpdate(userId, { cartData: {} });

            // Trả về phản hồi xác nhận đơn hàng
            new CREATED({
                message: 'Đơn hàng đã được đặt thành công, vui lòng thanh toán khi nhận hàng.',
            }).send(res);
        } catch (error) {
            throw new BadRequestError(error.message);
        }
    }
}

module.exports = new CODController();