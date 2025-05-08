'use strict';

const express = require('express');
const { asyncHandler } = require('../../helpers/asyncHandler');
const CategoryController = require('../../controller/category.controller');
const { checkTokenCookie } = require('../../middleware/checkAuth');
// const upload = require('../../config/upload.config');
const router = express.Router();
const multer = require('multer');
const storage = multer.memoryStorage();

const upload = multer({
    storage: storage,
    limits: {
        fileSize: 40 * 1024 * 1024, // Giới hạn 40MB
    },
});

router.get('/product/category/get', asyncHandler(CategoryController.getCategoryList));
router.get('/product/category/get/:categoryId', asyncHandler(CategoryController.getCategoryById));
router.post('/product/category/create', upload.single("categoryPic"), asyncHandler(CategoryController.createCategory));
router.delete('/product/category/softDelete/:categoryId', asyncHandler(CategoryController.softDeleteCategory));
router.delete('/product/category/delete/:categoryId', asyncHandler(CategoryController.deleteCategory));

module.exports = router;