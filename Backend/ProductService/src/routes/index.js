'use strict'

const express = require('express');
const router = express.Router();

router.use('/v1/api', require('./category'));
router.use('/v1/api', require('./product'));
router.use('/v1/api', require('./campaign'));
router.use('/v1/api', require('./voucher'));

module.exports = router;