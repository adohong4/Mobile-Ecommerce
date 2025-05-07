'use strict';

const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const slugify = require('slugify')

const DOCUMENT_NAME = 'Products';

const ProductSchema = new Schema(
    {
        title: { type: String, required: true },
        nameProduct: { type: String, required: true },
        product_slug: String,
        price: { type: Number, required: true },
        images: [String],
        recap: { type: String, required: true },
        description: { type: String, required: true },
        specifications: { type: String, required: true },
        category: { type: String },
        quantity: { type: Number, default: 0 },
        stock: { type: Number, default: 0 },
        active: { type: Boolean, default: true },
    },
    { minimize: false, timestamps: true }
);

//Document middleware: runs before .save() and .create()....
ProductSchema.pre('save', function (next) {
    this.product_slug = slugify(this.nameProduct, { lower: true })
    next();
})

ProductSchema.index({ _id: -1, category: 1 });

const productModel = mongoose.models.product || mongoose.model(DOCUMENT_NAME, ProductSchema);

module.exports = productModel;