'use strict';

const mongoose = require("mongoose");

const Schema = mongoose.Schema;

const DOCUMENT_NAME = 'Messages'

const MessageSchema = new Schema({
    senderId: { type: String, required: true },
    receiverId: { type: String, required: true },
    content: { type: String },
    image: { type: String },
}, { minimize: false, timestamps: true });

const MessageModel = mongoose.models.message || mongoose.model(DOCUMENT_NAME, MessageSchema)

module.exports = MessageModel;