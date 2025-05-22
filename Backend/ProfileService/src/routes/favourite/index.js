'use strict'

const express = require('express');
const { asyncHandler } = require('../../helpers/asyncHandler');
const FavouriteController = require('../../controllers/favourite.controller');
const { checkTokenCookie, checkTokenHeader } = require('../../middleware/checkAuth');
const router = express.Router();

router.post('/profile/favourite/add', checkTokenHeader, asyncHandler(FavouriteController.addToFavourite));
router.get('/profile/favourite/list', checkTokenHeader, asyncHandler(FavouriteController.getListFavourite));
router.post('/profile/favourite/remove', checkTokenHeader, asyncHandler(FavouriteController.removeFromFavourite));


module.exports = router;