'use strict'

const express = require('express');
const router = express.Router();

router.use('/v1/api', require('./profile'));
router.use('/v1/api/profile', require('./address'));
router.use('/v1/api/profile', require('./cart'));
router.use('/v1/api', require('./favourite'));
router.use('/v1/api', require('./saveAds'));
router.use('/v1/api', require('./comment'));
router.use('/v1/api', require('./admin'));
router.use('/v1/api', require('./viewedProduct'));

module.exports = router;