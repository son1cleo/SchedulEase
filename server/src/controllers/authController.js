const express = require('express');
const { register, login, requestPasswordReset, resetPassword } = require('../services/authService');

const router = express.Router();

// Register Route
router.post('/register', async (req, res) => {
    try {
        const result = await register(req.body);
        res.status(201).json(result);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

// Login Route
router.post('/login', async (req, res) => {
    try {
        const result = await login(req.body);
        res.json(result);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

// Request Password Reset Route
router.post('/reset-password-request', async (req, res) => {
    try {
        const result = await requestPasswordReset(req.body.email);
        res.json(result);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

// Reset Password Route
router.post('/reset-password', async (req, res) => {
    try {
        const result = await resetPassword(req.body.token, req.body.newPassword);
        res.json(result);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

module.exports = router;
