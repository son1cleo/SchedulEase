require('dotenv').config();
require('./config/db'); // Ensure database is connected on startup

const express = require('express');
const cors = require('cors');
const authRoutes = require('./controllers/authController');
const subscribeRoutes = require('./controllers/subscribeController');
const noteController = require('./controllers/noteController');
const checklistController = require('./controllers/checkListController');

const app = express();

// Enable CORS for all routes
app.use(cors());
app.use(express.json());

app.use('/auth', authRoutes);
app.use('/subscribe', subscribeRoutes);

app.post('/notes', noteController.createNote);
app.get('/notes/:userId', noteController.getNotes);

app.put('/notes/:id', noteController.updateNote);
app.delete('/notes/:id', noteController.deleteNote);

app.post('/checklist', checklistController.createChecklistItem);
app.get('/checklist/:noteId', checklistController.getChecklistItems);
app.put('/checklist/:id', checklistController.updateChecklistItem);
app.delete('/checklist/:id', checklistController.deleteChecklistItem);

const port = process.env.PORT || 5500;
app.listen(port, () => {
  console.log(`Server started at http://localhost:${port}`);
});