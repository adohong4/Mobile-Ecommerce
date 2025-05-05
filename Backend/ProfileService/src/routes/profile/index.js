'use strict'

const express = require('express');
const { asyncHandler } = require('../../helpers/asyncHandler');
const ProfileController = require('../../controllers/profile.controller');
const { checkTokenCookie } = require('../../middleware/checkAuth')
const router = express.Router();

router.get('/profile/get', checkTokenCookie, asyncHandler(ProfileController.getProfile));
router.post('/profile/update', checkTokenCookie, asyncHandler(ProfileController.updateInfoProfile));

module.exports = router;