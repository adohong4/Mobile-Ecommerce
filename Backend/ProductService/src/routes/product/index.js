'use strict';

const express = require('express');
const { asyncHandler } = require('../../helpers/asyncHandler');
const ProductController = require('../../controller/product.controller');
const { checkTokenCookie } = require('../../middleware/checkAuth');
const upload = require('../../config/upload.config');
const router = express.Router();

router.post('/product/create', asyncHandler(ProductController.createProduct));
router.get('/product/get', asyncHandler(ProductController.getProduct));
router.get('/product/get/:id', asyncHandler(ProductController.getProductById));
router.get('/product/get/:product_slug', asyncHandler(ProductController.getProductByslug));
router.get('/product/get/:nameProduct', asyncHandler(ProductController.getProductByName));
router.get('/product/update/:id', asyncHandler(ProductController.updateProduct));
router.get('/product/paginate', asyncHandler(ProductController.getProductsByPage));
router.get('/product/paginate/trash', asyncHandler(ProductController.paginateProductTrash));
router.delete('/product/delete/:id', asyncHandler(ProductController.deleteProduct));
router.delete('/product/softDelete/:id', asyncHandler(ProductController.softRestoreProduct));
router.delete('/product/updateQuantityProduct', asyncHandler(ProductController.updateQuantityProduct));

module.exports = router;