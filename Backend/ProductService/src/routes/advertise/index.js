'use strict'
const express = require('express');

const advertiseController = require('../../controller/advertis.controller')
const { asyncHandler } = require('../../helpers/asyncHandler');
const { checkTokenCookie } = require('../../middleware/checkAuth');
const { upload, convertToWebp } = require('../../config/upload.config');
const router = express.Router();

router.post('/product/advertise/create', upload.single('imageAds'), convertToWebp, asyncHandler(advertiseController.createAdvertise));
router.get('/product/advertise/get', asyncHandler(advertiseController.getAdvertise));
router.delete('/product/advertise/delete/:id', asyncHandler(advertiseController.deleteAdvertise));
router.put('/product/advertise/active/:id', asyncHandler(advertiseController.activeAdvertise));

router.get('/product/advertise/banner', asyncHandler(advertiseController.getBannerActive));
router.get('/product/advertise/adver', asyncHandler(advertiseController.getAdvertiseActive));

module.exports = router;