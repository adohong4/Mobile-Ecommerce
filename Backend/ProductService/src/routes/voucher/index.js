'use strict'
const express = require('express');

const voucherController = require('../../controller/voucher.controller')
const { asyncHandler } = require('../../helpers/asyncHandler');
const { checkTokenCookie, checkTokenHeader } = require('../../middleware/checkAuth')

const router = express.Router();

router.post('/product/voucher/create', asyncHandler(voucherController.createVoucher));
router.get('/product/voucher/get', asyncHandler(voucherController.getVoucherList));
router.get('/product/voucher/get/:id', asyncHandler(voucherController.getVoucherById));
router.get('/product/voucher/paginate', asyncHandler(voucherController.paginateVoucherList));
router.delete('/product/voucher/delete/:voucherId', asyncHandler(voucherController.softDeleteVoucher));
router.delete('/product/voucher/delete/:voucherId', asyncHandler(voucherController.deleteVoucher));
router.put('/product/voucher/update/:voucherId', asyncHandler(voucherController.updateVoucher));
router.post('/product/voucher/use/:id', asyncHandler(voucherController.useVoucher));

router.get('/product/voucher/user', checkTokenHeader, asyncHandler(voucherController.getUserVoucherList));
router.post('/product/voucher/pushUser', checkTokenHeader, asyncHandler(voucherController.addVoucherToUser));

module.exports = router;