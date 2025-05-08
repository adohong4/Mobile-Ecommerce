'use strict'
const express = require('express');

const voucherController = require('../../controller/voucher.controller')
const { asyncHandler } = require('../../helpers/asyncHandler');
const { checkTokenCookie } = require('../../middleware/checkAuth')

const router = express.Router();

router.post('/product/voucher/create', asyncHandler(voucherController.createVoucher));
router.get('/product/voucher/get', asyncHandler(voucherController.getVoucherList));
router.get('/product/voucher/paginate', asyncHandler(voucherController.paginateVoucherList));
router.delete('/product/voucher/delete/:voucherId', asyncHandler(voucherController.softDeleteVoucher));
router.delete('/product/voucher/delete/:voucherId', asyncHandler(voucherController.deleteVoucher));
router.put('/product/voucher/update/:voucherId', asyncHandler(voucherController.updateVoucher));
router.post('/product/voucher/use/:id', checkTokenCookie, asyncHandler(voucherController.updateVoucher));


module.exports = router;