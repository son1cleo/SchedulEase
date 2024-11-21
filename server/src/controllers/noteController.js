const Note = require('../models/note');
const Reminder = require('../models/reminder');
const mongoose = require('mongoose');
const ObjectId = mongoose.Types.ObjectId;


// Create a new note
exports.createNote = async (req, res) => {
  try {
    const { user_id, title, description, is_pinned, reminder_time } = req.body;

    const note = new Note({
      user_id,
      title,
      description,
      is_pinned,
    });

    await note.save();

    // Optionally create a reminder
    if (reminder_time) {
      const reminder = new Reminder({
        user_id,
        note_id: note._id,
        reminder_time,
      });
      await reminder.save();
    }

    res.status(201).json(note);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Get all notes for a specific user
exports.getNotes = async (req, res) => {
  console.log('Received GET /notes/:userId request');
  console.log('Params:', req.params);

  try {
    const userId = req.params.userId; // Extract userId from params
    if (!userId) {
      return res.status(400).json({ error: 'User ID is required' });
    }

    // Convert userId to ObjectId
    const userObjectId = new mongoose.Types.ObjectId(userId);

    // Find notes using the userObjectId
    const notes = await Note.find({ user_id: userObjectId });
    console.log('Notes fetched:', notes);

    res.status(200).json(notes);
  } catch (err) {
    console.error('Error fetching notes:', err.message);
    res.status(500).json({ error: err.message });
  }
};


// Update a note by ID
exports.updateNote = async (req, res) => {
  try {
    const { id } = req.params;
    const { title, description, is_pinned, reminder_time } = req.body;

    const updatedNote = await Note.findByIdAndUpdate(
      id,
      {
        title,
        description,
        is_pinned,
        reminder_time,
        updated_at: new Date(),
      },
      { new: true } // Return the updated document
    );

    if (!updatedNote) {
      return res.status(404).json({ message: 'Note not found' });
    }

    res.status(200).json(updatedNote);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};


// Delete a note by ID
exports.deleteNote = async (req, res) => {
  try {
    const note = await Note.findByIdAndDelete(req.params.id);
    if (!note) {
      return res.status(404).json({ error: 'Note not found' });
    }
    res.status(204).send(); // No content
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};
