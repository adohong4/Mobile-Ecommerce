'use strict'

const express = require('express')
const { asyncHandler } = require('../../helpers/asyncHandler')
const MessageController = require('../../controllers/message.controller')
const { checkTokenCookie, checkTokenHeader } = require('../../middleware/checkAuth')
const router = express.Router()

//signUp && Sign in
router.post('/message/send/:id', checkTokenHeader, asyncHandler(MessageController.sendMessage))
router.get('/message/get/:id', checkTokenHeader, asyncHandler(MessageController.getMessages))

module.exports = router;