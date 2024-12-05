require('dotenv').config();
require('./config/db'); // Ensure database is connected on startup

const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const authRoutes = require('./controllers/authController');
const subscribeRoutes = require('./controllers/subscribeController');
const noteController = require('./controllers/noteController');
const reminderController = require('./controllers/reminderController');
const checklistController = require('./controllers/checkListController');
const taskRoutes = require('./routes/taskRoutes');
const taskController = require('./controllers/taskController');

const app = express();

// Enable CORS for all routes
app.use(cors());
app.use(express.json());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use('/auth', authRoutes);
app.use('/subscribe', subscribeRoutes);
app.use('/api/tasks', taskRoutes);

app.post('/notes', noteController.createNote);
app.get('/notes/:userId', noteController.getNotes);

app.put('/notes/:id', noteController.updateNote);
app.delete('/notes/:id', noteController.deleteNote);

app.post('/checklist', checklistController.createChecklistItem);
app.get('/checklist/:noteId', checklistController.getChecklistItems);
app.put('/checklist/:id', checklistController.updateChecklistItem);
app.delete('/checklist/:id', checklistController.deleteChecklistItem);

app.get('/reminders/:userId', reminderController.getReminders);

app.post('/create-note-reminder', async (req, res) => {
  try {
    const { note_id, reminder_time } = req.body;
    if (!note_id || !reminder_time) {
      return res.status(400).send('Note ID and reminder time are required.');
    }

    await reminderService.createNoteReminder(note_id, reminder_time);
    res.status(201).send('Note reminder created.');
  } catch (error) {
    res.status(500).send(`Error creating note reminder: ${error.message}`);
  }
});

// Endpoint to update note reminder status
app.put('/update-note-reminder-status', async (req, res) => {
  try {
    const { reminder_id, status } = req.body;
    if (!reminder_id || !status) {
      return res.status(400).send('Reminder ID and status are required.');
    }

    await reminderService.updateNoteReminderStatus(reminder_id, status);
    res.status(200).send('Note reminder status updated.');
  } catch (error) {
    res.status(500).send(`Error updating note reminder status: ${error.message}`);
  }
});

// Endpoint to create a schedule reminder
app.post('/create-schedule-reminder', async (req, res) => {
  try {
    const { task_id, due_date } = req.body;
    if (!task_id || !due_date) {
      return res.status(400).send('Task ID and due date are required.');
    }

    await reminderService.createScheduleReminder(task_id, due_date);
    res.status(201).send('Schedule reminder created.');
  } catch (error) {
    res.status(500).send(`Error creating schedule reminder: ${error.message}`);
  }
});

// Endpoint to update schedule reminder status
app.put('/update-schedule-reminder-status', async (req, res) => {
  try {
    const { reminder_id, status } = req.body;
    if (!reminder_id || !status) {
      return res.status(400).send('Reminder ID and status are required.');
    }

    await reminderService.updateScheduleReminderStatus(reminder_id, status);
    res.status(200).send('Schedule reminder status updated.');
  } catch (error) {
    res.status(500).send(`Error updating schedule reminder status: ${error.message}`);
  }
});

const port = process.env.PORT || 5500;
app.listen(port, () => {
  console.log(`Server started at http://localhost:${port}`);
});