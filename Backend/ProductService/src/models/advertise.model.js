'use strict';

const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const DOCUMENT_NAME = 'advertises'

const AdvertiseSchema = new Schema({
    imageAds: { type: String },
    classify: { type: String, enum: ['BANNER', 'ADVERTISE'], required: true },
    recap: { type: String },
    status: { type: Boolean, default: false }
}, { minimize: false, timestamps: true });

const advertiseModel = mongoose.models.advertise || mongoose.model(DOCUMENT_NAME, AdvertiseSchema)

module.exports = advertiseModel;