'use strict'

const express = require('express');
const { asyncHandler } = require('../../helpers/asyncHandler');
const AddressController = require('../../controllers/address.controller');
const { checkTokenCookie } = require('../../middleware/checkAuth');
const upload = require('../../config/upload.config');
const router = express.Router();

router.post('/address/create', checkTokenCookie, asyncHandler(AddressController.createAddress));
router.get('/address/get', checkTokenCookie, asyncHandler(AddressController.getListAddress));
router.delete('/address/delete/:addressId', checkTokenCookie, asyncHandler(AddressController.deleteAddress));

module.exports = router;