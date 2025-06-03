'use strict';

const mongoose = require("mongoose");

const Schema = mongoose.Schema;

const DOCUMENT_NAME = 'Users'

const UserSchema = new Schema({
    username: { type: String, required: true, unique: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: false },
    hashedPassword: { type: String, required: false },
    role: { type: String, enum: ['USER', 'ADMIN'], default: 'USER' },
    cartData: {
        type: Object,
        default: {},
    },
    active: { type: Boolean, default: true }
}, { minimize: false, timestamps: true });

function arrayLimit(val) {
    return val.length <= 20;
}

const identityModel = mongoose.models.user || mongoose.model(DOCUMENT_NAME, UserSchema)

module.exports = identityModel;