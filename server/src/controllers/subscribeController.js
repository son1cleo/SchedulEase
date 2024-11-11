const express = require('express');
const { processSubscription } = require('./payments/subscriptionController');

const router = express.Router();

// Subscribe Route
router.post('/', async (req, res) => {
    try {
        const { paymentMethod, userId } = req.body; // Destructure paymentMethod and userId from the request body
        const result = await processSubscription({ paymentMethod, userId }); // Pass paymentMethod and userId to processSubscription
        res.json(result);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

module.exports = router;
