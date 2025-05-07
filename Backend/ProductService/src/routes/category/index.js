'use strict'

const express = require('express');
const { asyncHandler } = require('../../helpers/asyncHandler');
const CategoryController = require('../../controller/category.controller');
const { checkTokenCookie } = require('../../middleware/checkAuth');
const upload = require('../../config/upload.config');
const router = express.Router();

router.get('/category/get', asyncHandler(CategoryController.getCategoryList));
router.get('/category/get/:categoryId', asyncHandler(CategoryController.getCategoryById));
router.post('/category/create', upload.single("categoryPic"), asyncHandler(CategoryController.createCategory));
router.delete('/category/softDelete/:categoryId', asyncHandler(CategoryController.softDeleteCategory));
router.delete('/category/delete/:categoryId', asyncHandler(CategoryController.deleteCategory));

module.exports = router;