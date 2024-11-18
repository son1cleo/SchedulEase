const Note = require('../models/note');
const Reminder = require('../models/reminder');


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
  try {
    console.log(req.params.userId); //node er console e dekhar jonno
    const notes = await Note.find({ user_id: req.params.userId }).sort({ is_pinned: -1, updated_at: -1 });
    res.json(notes); // Return sorted notes
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Update a note by ID
exports.updateNote = async (req, res) => {
  try {
    const updateData = { ...req.body, updated_at: new Date() }; // Update `updated_at` field
    const note = await Note.findByIdAndUpdate(req.params.id, updateData, { new: true });
    if (!note) {
      return res.status(404).json({ error: 'Note not found' });
    }
    res.json(note); // Return the updated note
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
    res.status(204).send(); // No content
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};
