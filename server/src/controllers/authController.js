const express = require('express');
const { register, login, requestPasswordReset, resetPassword } = require('../services/authService');
const auth = require('../middleware/auth');
const User = require('../models/User');
const { updateUser } = require('../services/userUpdateService');

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
        const { email } = req.body; // Destructure email from the request body
        const result = await requestPasswordReset(email); // Pass only the email
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

router.put("/update", auth, async (req, res) => {
    try {
        const userId = req.user.userId; // Extract userId from req.user
        const updatedFields = req.body; // Fields to update
        const result = await updateUser(userId, updatedFields);
        res.json(result); // Respond with success
    } catch (error) {
        if (!res.headersSent) {
            res.status(400).json({ message: error.message });
        }
    }
});


module.exports = router;
