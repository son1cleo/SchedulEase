const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const authRoutes = require('./controllers/authController');

dotenv.config();

const app = express();
app.use(express.json());

// Initialize database connection using Singleton pattern
require('./config/db');

// Use authentication routes
app.use('/auth', authRoutes);

const port = process.env.PORT || 5000;
app.listen(port, () => {
    console.log(`Server Started at http://127.0.0.1:${port}/`);
});
