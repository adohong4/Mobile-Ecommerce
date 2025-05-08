'use strict'

const express = require('express')

const { asyncHandler } = require('../../helpers/asyncHandler')
const { checkTokenCookie } = require('../../middleware/checkAuth')
const paymentController = require('../../controllers/cod.controller')
const stripeController = require('../../controllers/stripe.controller')
const zalopayController = require('../../controllers/zalopay.controller')

const router = express.Router()

//Payment
router.post('/payment/cod/verify', checkTokenCookie, asyncHandler(paymentController.CODplaceOrder))

//Stripe
router.post('/payment/stripe/place', checkTokenCookie, asyncHandler(stripeController.placeOrder))
router.post('/payment/stripe/verify', checkTokenCookie, asyncHandler(stripeController.verifyOrder))

//ZaloPay
router.post('/payment/zalopay/payment', checkTokenCookie, asyncHandler(zalopayController.placeOrder))
router.post('/payment/zalopay/verify', checkTokenCookie, asyncHandler(zalopayController.verifyOrder))


module.exports = router;