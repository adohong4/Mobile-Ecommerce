'use strict'

const express = require('express');
const { asyncHandler } = require('../../helpers/asyncHandler');
const ProfileController = require('../../controllers/profile.controller');
const { checkTokenCookie, checkTokenHeader } = require('../../middleware/checkAuth');
const router = express.Router();
const multer = require('multer');
const storage = multer.memoryStorage();

const upload = multer({
    storage: storage,
    limits: {
        fileSize: 40 * 1024 * 1024, // Giới hạn 40MB
    },
});

router.get('/profile/get', checkTokenHeader, asyncHandler(ProfileController.getProfile));
router.post('/profile/update', checkTokenHeader, asyncHandler(ProfileController.updateInfoProfile));
router.post('/profile/image', checkTokenHeader, upload.single("profilePic"), asyncHandler(ProfileController.updateProfilePic));

module.exports = router;