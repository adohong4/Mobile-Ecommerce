'use strict';

const express = require('express');
const { asyncHandler } = require('../../helpers/asyncHandler')
const OrderAdminController = require('../../controllers/admin/order.controller');
const StatisticController = require('../../controllers/admin/statistic.controller');
const AccountController = require('../../controllers/admin/account.controller');

const router = express.Router();

//Admin
router.get('/profile/order/get', asyncHandler(OrderAdminController.getOrders));
router.get('/profile/order/get/:id', asyncHandler(OrderAdminController.getOrderById));

router.get('/profile/order/paginate', asyncHandler(OrderAdminController.paginateOder));
router.get('/profile/order/trash/paginate', asyncHandler(OrderAdminController.paginateOderTrash));

router.get('/profile/order/search/:id', asyncHandler(OrderAdminController.searchById));

router.put('/profile/order/update', asyncHandler(OrderAdminController.updateStatusOrder));

router.delete('/profile/order/delete/:id', asyncHandler(OrderAdminController.deleteOrder));
router.delete('/profile/order/status/:id', asyncHandler(OrderAdminController.toggleOrderStatus)); //delete && restore

router.get('/profile/online/user', asyncHandler(AccountController.getAccounts));


router.get('/profile/statistic/get', asyncHandler(StatisticController.productStatisticTable));
router.get('/profile/statistic/category/get', asyncHandler(StatisticController.productStatisticCategory)); //cot
router.get('/profile/statistic/revenue/:time', asyncHandler(StatisticController.getRevenueStats));

module.exports = router;