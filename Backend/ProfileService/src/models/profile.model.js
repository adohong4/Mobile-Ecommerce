'use strict';

const mongoose = require("mongoose");

const Schema = mongoose.Schema;

const DOCUMENT_NAME = 'Profiles'

const AddressSchema = new Schema({
    fullname: { type: String },
    phone: { type: String },
    street: { type: String },
    precinct: { type: String },
    city: { type: String },
    province: { type: String },
})

const ProfileSchema = new Schema({
    userId: { type: String, required: true },
    profilePic: { type: String },
    fullName: { type: String },
    gender: { type: String, enum: ['MALE', 'FEMALE', 'OTHER'] },
    dateOfBirth: { type: Date },
    phoneNumber: { type: String },
    address: [AddressSchema],
}, { minimize: false, timestamps: true });

const profileModel = mongoose.models.profile || mongoose.model(DOCUMENT_NAME, ProfileSchema);

module.exports = profileModel;