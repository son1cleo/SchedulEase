const express = require('express');
const authRoutes = require('./controllers/authController');
const subscribeRoutes = require('./controllers/subscribeController');
const noteController = require('./controllers/noteController');
require('dotenv').config();
require('./config/db'); // Ensure database is connected on startup
const cors = require('cors');
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

const port = process.env.PORT || 5500;
app.listen(port, () => {
    console.log(`Server Started at http://127.0.0.1:${port}/`);
});