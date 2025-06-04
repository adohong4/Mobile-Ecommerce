'use strict'

const express = require('express');
const { asyncHandler } = require('../../helpers/asyncHandler');
const userAdsController = require('../../controllers/userAds.controller');
const { checkTokenCookie } = require('../../middleware/checkAuth');
const router = express.Router();

router.post('/profile/ads/add', asyncHandler(userAdsController.addToAds));
router.get('/profile/ads/list', asyncHandler(userAdsController.getAds));
router.post('/profile/ads/remove', asyncHandler(userAdsController.removeFromAds));


module.exports = router;