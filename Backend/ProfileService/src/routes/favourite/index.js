'use strict'

const express = require('express');
const { asyncHandler } = require('../../helpers/asyncHandler');
const FavouriteController = require('../../controllers/favourite.controller');
const { checkTokenCookie } = require('../../middleware/checkAuth');
const router = express.Router();

router.post('/profile/favourite/add', checkTokenCookie, asyncHandler(FavouriteController.addToFavourite));
router.get('/profile/favourite/list', checkTokenCookie, asyncHandler(FavouriteController.getListFavourite));
router.post('/profile/favourite/remove', checkTokenCookie, asyncHandler(FavouriteController.removeFromFavourite));


module.exports = router;