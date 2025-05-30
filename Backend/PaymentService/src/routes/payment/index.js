'use strict'

const express = require('express')

const { asyncHandler } = require('../../helpers/asyncHandler')
const { checkTokenCookie, checkTokenHeader } = require('../../middleware/checkAuth')
const paymentController = require('../../controllers/cod.controller')
const stripeController = require('../../controllers/stripe.controller')
const zalopayController = require('../../controllers/zalopay.controller')

const router = express.Router()

//Payment
router.post('/payment/cod/verify', checkTokenHeader, asyncHandler(paymentController.CODplaceOrder))

//Stripe
router.post('/payment/stripe/place', checkTokenHeader, asyncHandler(stripeController.placeOrder))
router.post('/payment/stripe/verify', checkTokenHeader, asyncHandler(stripeController.verifyOrder))

//ZaloPay
router.post('/payment/zalopay/payment', checkTokenHeader, asyncHandler(zalopayController.placeOrder))
router.post('/payment/zalopay/verify', checkTokenHeader, asyncHandler(zalopayController.verifyOrder))


module.exports = router;