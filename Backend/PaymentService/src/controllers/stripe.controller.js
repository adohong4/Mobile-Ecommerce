'use strict';

const userModel = require('../models/identity.model');
const orderModel = require('../models/order.model');
const { BadRequestError } = require('../core/error.response');
const { CREATED, SuccessResponse } = require('../core/success.response');

const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);

class StripeController {
    placeOrder = async (req, res) => {
        const userId = req.user;
        const frontend_url = process.env.URL_FRONTEND || 'http://localhost:3000';
        const { items, amount, address } = req.body;

        // Kiểm tra dữ liệu đầu vào
        if (!items || !Array.isArray(items) || items.length === 0) {
            throw new BadRequestError('Danh sách sản phẩm không hợp lệ');
        }
        if (!amount || typeof amount !== 'number' || amount <= 0) {
            throw new BadRequestError('Số tiền không hợp lệ');
        }
        if (!address || !address.fullname || !address.street || !address.city || !address.province) {
            throw new BadRequestError('Địa chỉ giao hàng không đầy đủ');
        }

        let newOrder;
        try {
            if (amount > 99000000) {
                throw new BadRequestError('Vượt quá hạn mức giao dịch (99 triệu VND)');
            }

            // Tạo đơn hàng
            newOrder = new orderModel({
                userId,
                items,
                amount,
                address,
                paymentMethod: 'online',
                payment: false,
            });

            await newOrder.save();

            // Tạo line_items cho Stripe
            const line_items = items.map((item) => {
                if (!item.nameProduct) {
                    throw new BadRequestError('Tên sản phẩm không được cung cấp');
                }
                return {
                    price_data: {
                        currency: 'vnd',
                        product_data: {
                            name: item.nameProduct,
                        },
                        unit_amount: Math.round(item.price),
                    },
                    quantity: item.quantity,
                };
            });

            // Kiểm tra tham số để quyết định sử dụng Checkout Session
            const useCheckoutSession = req.query.useCheckoutSession === 'true' || req.body.useCheckoutSession === true;

            // Luôn tạo Checkout Session cho cả web và mobile nếu useCheckoutSession là true
            const session = await stripe.checkout.sessions.create({
                line_items,
                mode: 'payment',
                payment_method_types: ['card'],
                success_url: `${frontend_url}/verify?success=true&orderId=${newOrder._id}`,
                cancel_url: `${frontend_url}/verify?success=false&orderId=${newOrder._id}`,
                metadata: { orderId: newOrder._id.toString() },
            });

            // Xóa giỏ hàng
            await userModel.findByIdAndUpdate(userId, { cartData: {} });

            new SuccessResponse({
                message: 'Tạo phiên thanh toán Stripe thành công',
                metadata: {
                    sessionId: session.id,
                    sessionUrl: session.url,
                    orderId: newOrder._id.toString(),
                },
            }).send(res);
        } catch (error) {
            // Xóa đơn hàng nếu có lỗi
            if (newOrder?._id) {
                await orderModel.findByIdAndDelete(newOrder._id);
            }
            throw new BadRequestError(error.message || 'Lỗi khi tạo đơn hàng');
        }
    };

    verifyOrder = async (req, res) => {
        const { orderId, success } = req.body;

        if (!orderId) {
            throw new BadRequestError('ID đơn hàng không hợp lệ');
        }

        try {
            const order = await orderModel.findById(orderId);
            if (!order) {
                throw new BadRequestError('Không tìm thấy đơn hàng');
            }

            if (success === 'true') {
                await orderModel.findByIdAndUpdate(orderId, { payment: true });
                new SuccessResponse({
                    message: 'Thanh toán thành công',
                    metadata: { orderId, status: 'paid' },
                }).send(res);
            } else {
                await orderModel.findByIdAndDelete(orderId);
                new SuccessResponse({
                    message: 'Thanh toán không thành công, đơn hàng đã bị hủy',
                    metadata: { orderId, status: 'cancelled' },
                }).send(res);
            }
        } catch (error) {
            throw new BadRequestError(error.message || 'Lỗi khi xác minh đơn hàng');
        }
    };
}

module.exports = new StripeController();