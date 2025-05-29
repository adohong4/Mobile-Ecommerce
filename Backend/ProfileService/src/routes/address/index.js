'use strict'

const express = require('express');
const { asyncHandler } = require('../../helpers/asyncHandler');
const AddressController = require('../../controllers/address.controller');
const { checkTokenCookie, checkTokenHeader } = require('../../middleware/checkAuth');
const upload = require('../../config/upload.config');
const router = express.Router();

router.post('/address/create', checkTokenHeader, asyncHandler(AddressController.createAddress));
router.get('/address/get', checkTokenHeader, asyncHandler(AddressController.getListAddress));
router.delete('/address/delete/:addressId', checkTokenHeader, asyncHandler(AddressController.deleteAddress));

module.exports = router;