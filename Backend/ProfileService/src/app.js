'use strict';

const express = require('express');
const cors = require('cors');
const connectDB = require('./config/db.mongodb');
const compression = require('compression');
const cookieParser = require('cookie-parser');
const app = express();

// Init middlewares
app.use(compression());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(
    cors({
        origin: "http://localhost:5174",
        credentials: true,
    })
);

// Init db
connectDB();

// Serve static files

// Init router
app.use('', require('./routes'));
app.use('/images', express.static('upload'));

// Handling errors
app.use((req, res, next) => {
    const error = new Error('Not Found');
    error.status = 404;
    next(error);
});

app.use((error, req, res, next) => {
    const statusCode = error.status || 500;
    return res.status(statusCode).json({
        status: 'error',
        code: statusCode,
        stack: error.stack,
        message: error.message || 'Internal Server Error'
    });
});

module.exports = app;