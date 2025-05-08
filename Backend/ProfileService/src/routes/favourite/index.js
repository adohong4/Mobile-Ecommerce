'use strict'

const express = require('express');
const { asyncHandler } = require('../../helpers/asyncHandler');
const FavouriteController = require('../../controllers/favourite.controller');
const { checkTokenCookie } = require('../../middleware/checkAuth');
const router = express.Router();

router.get('/favourite/add', checkTokenCookie, asyncHandler(FavouriteController.addToFavourite));
router.post('/favourite/list', checkTokenCookie, asyncHandler(FavouriteController.getListFavourite));
router.post('/favourite/remove', checkTokenCookie, asyncHandler(FavouriteController.removeFromFavourite));


module.exports = router;