'use strict'
const express = require('express');

const campaignController = require('../../controller/campaign.controller')
const { asyncHandler } = require('../../helpers/asyncHandler');
const { checkTokenCookie } = require('../../middleware/checkAuth')

const router = express.Router();

router.post('/product/campaign/create', asyncHandler(campaignController.createCampaign))

router.get('/product/campaign/get', asyncHandler(campaignController.getAllCampaign))
router.get('/product/campaign/get/:id', asyncHandler(campaignController.getCampaignById))

router.put('/product/campaign/update/:id', asyncHandler(campaignController.updateCampaignById))

router.delete('/product/campaign/active/:id', asyncHandler(campaignController.activeCampaign))//delete && restore
router.delete('/product/campaign/delete/:id', asyncHandler(campaignController.deleteCampaign))

router.get('/product/campaign/paginate', asyncHandler(campaignController.paginateCampaign))
router.get('/product/campaign/trash/paginate', asyncHandler(campaignController.paginateCampaignTrash))

router.get('/product/campaign/search/:code', asyncHandler(campaignController.searchCampaignByCode))

//custom
router.post('/product/campaign/addToCampaign', asyncHandler(campaignController.addToCampaign))
router.post('/product/campaign/removeFromCampaign', asyncHandler(campaignController.removeFromCampaign))

router.get('/product/campaign/updateProductPrice', asyncHandler(campaignController.updateProductPricesForCampaign))
router.get('/product/campaign/updateProductPrice/:productId', asyncHandler(campaignController.updateProductPricesForCampaignBySlug))
module.exports = router;