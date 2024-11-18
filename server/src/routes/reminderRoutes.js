const express = require('express');
const reminderController = require('../controllers/reminderController');
const router = express.Router();

// Define routes for reminders
router.post('/', reminderController.createReminder); // Create a reminder
router.get('/:userId', reminderController.getReminders); // Get reminders for a user
router.put('/:id', reminderController.updateReminder); // Update a reminder
router.delete('/:id', reminderController.deleteReminder); // Delete a reminder

module.exports = router;
