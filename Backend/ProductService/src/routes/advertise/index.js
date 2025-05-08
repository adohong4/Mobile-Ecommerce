'use strict'
const express = require('express');

const advertiseController = require('../../controller/advertis.controller')
const { asyncHandler } = require('../../helpers/asyncHandler');
const { checkTokenCookie } = require('../../middleware/checkAuth')
const router = express.Router();
const multer = require('multer');
const storage = multer.memoryStorage();

const upload = multer({
    storage: storage,
    limits: {
        fileSize: 40 * 1024 * 1024, // Giới hạn 40MB
    },
});

router.post('/product/advertise/create', upload.single('imageAds'), asyncHandler(advertiseController.createAdvertise));
router.get('/product/advertise/get', asyncHandler(advertiseController.getAdvertise));
router.delete('/product/advertise/delete/:id', asyncHandler(advertiseController.deleteAdvertise));
router.put('/product/advertise/active/:id', asyncHandler(advertiseController.activeAdvertise));

module.exports = router;