const express = require('express');
const { processSubscription } = require('./payments/subscriptionController');
const User = require('../models/User');

const router = express.Router();

// Subscribe Route
router.post('/api', async (req, res) => {
    try {
        const { paymentMethod, userId } = req.body;
        console.log('Received request:', { paymentMethod, userId }); // Log the received request data
        const result = await processSubscription({ paymentMethod, userId });
        res.json(result);
    } catch (error) {
        console.error('Error in subscription route:', error);
        res.status(400).json({ message: error.message });
    }
});

// Endpoint to refresh user subscription
router.post('/refresh', async (req, res) => {
    const { userId } = req.body;

    try {
        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }
        // Send back the updated user data, including subscription status
        res.status(200).json({ user });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

module.exports = router;
