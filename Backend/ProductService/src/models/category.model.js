'use strict';

const mongoose = require("mongoose");

const Schema = mongoose.Schema;

const DOCUMENT_NAME = 'Categories'

const CategorySchema = new Schema({
    category: { type: String },
    categoryIds: { type: String },
    categoryPic: { type: String },
    active: { type: Boolean, default: true }
}, { minimize: false, timestamps: true });

const categoryModel = mongoose.models.category || mongoose.model(DOCUMENT_NAME, CategorySchema)

module.exports = categoryModel;