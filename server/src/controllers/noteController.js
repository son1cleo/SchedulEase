// server/src/controllers/noteController.js
const Note = require('../models/note'); // Updated path to match new file name

// Create a new note
exports.createNote = async (req, res) => {
  try {
    const note = new Note({
      user_id: req.body.user_id,
      title: req.body.title,
      description: req.body.description,
      is_pinned: req.body.is_pinned,
    });
    await note.save();
    res.status(201).json(note);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Get all notes for a specific user
exports.getNotes = async (req, res) => {
  try {
    const notes = await Note.find({ user_id: req.params.userId });
    res.json(notes);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Update a note by ID
exports.updateNote = async (req, res) => {
  try {
    const note = await Note.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!note) {
      return res.status(404).json({ error: 'Note not found' });
    }
    res.json(note);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Delete a note by ID
exports.deleteNote = async (req, res) => {
  try {
    const note = await Note.findByIdAndDelete(req.params.id);
    if (!note) {
      return res.status(404).json({ error: 'Note not found' });
    }
    res.status(204).send();
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};
