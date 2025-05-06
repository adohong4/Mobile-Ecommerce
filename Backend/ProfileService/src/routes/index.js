'use strict'

const express = require('express');
const router = express.Router();

router.use('/v1/api', require('./profile'));
router.use('/v1/api', require('./address'));

module.exports = router;