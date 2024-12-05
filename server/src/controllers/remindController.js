const Reminder = require('../models/reminder'); // Import the Reminder model
const mongoose = require('mongoose');
const ObjectId = mongoose.Types.ObjectId;

// Create a new reminder
exports.createReminder = async (req, res) => {
    try {
        const { user_id, note_id, reminder_time } = req.body;

        const reminder = new Reminder({
            user_id,
            note_id,
            reminder_time,
        });

        await reminder.save();
        res.status(201).json(reminder);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

// Get reminders for a specific user
exports.getReminders = async (req, res) => {
    try {
        const { userId } = req.params;

        // Validate userId
        if (!mongoose.Types.ObjectId.isValid(userId)) {
            return res.status(400).json({ error: 'Invalid User ID' });
        }

        const userObjectId = new mongoose.Types.ObjectId(userId);
        const reminders = await Reminder.find({ user_id: userObjectId }).populate('note_id');

        res.json(reminders);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

// Update a reminder by ID
exports.updateReminder = async (req, res) => {
    try {
        const { id } = req.params;
        const { reminder_time } = req.body;

        const reminder = await Reminder.findByIdAndUpdate(
            id,
            { reminder_time, updated_at: new Date() },
            { new: true }
        );

        if (!reminder) {
            return res.status(404).json({ error: 'Reminder not found' });
        }

        res.json(reminder);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

// Delete a reminder by ID
exports.deleteReminder = async (req, res) => {
    try {
        const { id } = req.params;

        const reminder = await Reminder.findByIdAndDelete(id);
        if (!reminder) {
            return res.status(404).json({ error: 'Reminder not found' });
        }

        res.status(204).send();
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};