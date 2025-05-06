'use strict'

const express = require('express');
const { asyncHandler } = require('../../helpers/asyncHandler');
const ProfileController = require('../../controllers/profile.controller');
const { checkTokenCookie } = require('../../middleware/checkAuth');
const upload = require('../../config/upload.config');
const router = express.Router();

router.get('/profile/get', checkTokenCookie, asyncHandler(ProfileController.getProfile));
router.post('/profile/update', checkTokenCookie, asyncHandler(ProfileController.updateInfoProfile));
router.post('/profile/image', checkTokenCookie, upload.single("profilePic"), asyncHandler(ProfileController.updateProfilePic));

module.exports = router;