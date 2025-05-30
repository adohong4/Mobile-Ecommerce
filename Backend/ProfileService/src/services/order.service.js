'use strict'

const orderModel = require('../models/order.model');
const { BadRequestError } = require('../core/error.response');

class OrderService {
    static async orderData(req, res) {
        try {
            const userId = req.user._id;
            const orderData = await orderModel.find({ userId })
                .select('userId amount status paymentMethod payment statusActive date items.id items.price items.quantity')
                .sort({ createdAt: -1 })
                .exec();
            return orderData;
        } catch (error) {
            throw error;
        }
    }

    static async cancelOrder(req, res) {
        try {
            const { orderId, reasonCancel } = req.body;

            const order = await orderModel.findById(orderId);
            if (!order) {
                throw new BadRequestError('Không tìm thấy đơn hàng');
            }

            if (order.paymentMethod !== 'cod') {
                throw new BadRequestError('Đã thanh toán, Không thể hủy đơn hàng đã được giao');
            }

            if (order.status === 'delivered') {
                throw new BadRequestError('Không thể hủy đơn hàng đã được giao');
            }
            if (order.status === 'cancelled') {
                throw new BadRequestError('Đơn hàng đã bị hủy trước đó');
            }

            const updatedOrder = await orderModel.findByIdAndUpdate(
                orderId,
                {
                    $set: {
                        status: 'cancelled',
                        reasonCancel: reasonCancel || ''
                    }
                },
                { new: true }
            );

            return updatedOrder;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = OrderService;