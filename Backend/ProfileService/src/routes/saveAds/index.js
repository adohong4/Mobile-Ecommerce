'use strict'

const express = require('express');
const { asyncHandler } = require('../../helpers/asyncHandler');
const userAdsController = require('../../controllers/userAds.controller');
const { checkTokenCookie } = require('../../middleware/checkAuth');
const router = express.Router();

router.post('/profile/ads/add', checkTokenCookie, asyncHandler(userAdsController.addToAds));
router.get('/profile/ads/list', checkTokenCookie, asyncHandler(userAdsController.getAds));
router.post('/profile/ads/remove', checkTokenCookie, asyncHandler(userAdsController.removeFromAds));


module.exports = router;