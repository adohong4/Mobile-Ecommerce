'use strict'

const express = require('express')
const { asyncHandler } = require('../../helpers/asyncHandler')
const MessageController = require('../../controllers/message.controller')
const { checkTokenCookie } = require('../../middleware/checkAuth')
const router = express.Router()

//signUp && Sign in
router.post('/message/send/:id', checkTokenCookie, asyncHandler(MessageController.sendMessage))
router.get('/message/get/:id', checkTokenCookie, asyncHandler(MessageController.getMessages))

module.exports = router;