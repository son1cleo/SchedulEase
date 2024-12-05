const express = require('express');
const router = express.Router();
const ReminderService = require('../services/reminderService');

const reminderService = new ReminderService();

// Endpoint to create note reminder
router.post('/create-note-reminder', async (req, res) => {
    const { note_id, reminder_time } = req.body;
    await reminderService.createNoteReminder(note_id, reminder_time);
    res.status(201).send('Note reminder created.');
});

// Endpoint to update note reminder status
router.put('/update-note-reminder-status', async (req, res) => {
    const { reminder_id, status } = req.body;
    await reminderService.updateNoteReminderStatus(reminder_id, status);
    res.status(200).send('Note reminder status updated.');
});

// Endpoint to create schedule reminder
router.post('/create-schedule-reminder', async (req, res) => {
    const { task_id, due_date } = req.body;
    await reminderService.createScheduleReminder(task_id, due_date);
    res.status(201).send('Schedule reminder created.');
});

// Endpoint to update schedule reminder status
router.put('/update-schedule-reminder-status', async (req, res) => {
    const { reminder_id, status } = req.body;
    await reminderService.updateScheduleReminderStatus(reminder_id, status);
    res.status(200).send('Schedule reminder status updated.');
});

module.exports = router;