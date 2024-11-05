const express = require('express');
const app = express();

const mongoose = require('mongoose');
require('dotenv').config(); // Load environment variables from .env file

// Use the environment variable for the MongoDB connection string
mongoose.connect(process.env.MONGO_URI).then(function () {
    app.get("/", function (req, res) {
        res.send("This is the home page");
    });
}).catch(err => {
    console.log('Failed to connect to MongoDB', err);
});

// Get the port from environment variables or use default (5000)
const port = process.env.PORT;

app.listen(port, function () {
    console.log(`Server Started at http://127.0.0.1:${port}/`);
});