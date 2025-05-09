'use strict'

const express = require('express');
const { asyncHandler } = require('../../helpers/asyncHandler');
const ProfileController = require('../../controllers/profile.controller');
const { checkTokenCookie } = require('../../middleware/checkAuth');
const router = express.Router();
const multer = require('multer');
const storage = multer.memoryStorage();

const upload = multer({
    storage: storage,
    limits: {
        fileSize: 40 * 1024 * 1024, // Giới hạn 40MB
    },
});

router.get('/profile/get', checkTokenCookie, asyncHandler(ProfileController.getProfile));
router.post('/profile/update', checkTokenCookie, asyncHandler(ProfileController.updateInfoProfile));
router.post('/profile/image', checkTokenCookie, upload.single("profilePic"), asyncHandler(ProfileController.updateProfilePic));

module.exports = router;