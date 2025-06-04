'use strict'

const express = require('express');
const { asyncHandler } = require('../../helpers/asyncHandler');
const viewedProductController = require('../../controllers/viewedProduct.controller');
const { checkTokenHeader } = require('../../middleware/checkAuth');
const router = express.Router();

router.post('/profile/viewedProduct/add', checkTokenHeader, asyncHandler(viewedProductController.addViewedProduct));
router.get('/profile/viewedProduct/list', checkTokenHeader, asyncHandler(viewedProductController.getViewedProducts));

module.exports = router;