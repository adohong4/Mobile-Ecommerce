'use strict'

const express = require('express');
const { asyncHandler } = require('../../helpers/asyncHandler');
const AddressController = require('../../controllers/address.controller');
const { checkTokenCookie, checkTokenHeader } = require('../../middleware/checkAuth');
const router = express.Router();

router.post('/address/create', checkTokenHeader, asyncHandler(AddressController.createAddress));
router.get('/address/get', checkTokenHeader, asyncHandler(AddressController.getListAddress));
router.delete('/address/delete/:addressId', checkTokenHeader, asyncHandler(AddressController.deleteAddress));

router.put('/address/update/:addressId', checkTokenHeader, asyncHandler(AddressController.setDefaultAddress));

module.exports = router;