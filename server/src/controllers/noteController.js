const Note = require('../models/note');
const Reminder = require('../models/reminder');
const ChecklistItem = require('../models/checkListItem');
const mongoose = require('mongoose');

// Create a new note with checklists and reminder
exports.createNote = async (req, res) => {
  try {
    const { user_id, title, description, checklist, is_pinned, reminder_time } = req.body;
    console.log("Request body:", req.body);

    // Validate required fields
    if (!user_id || !title || !description) {
      return res.status(400).json({ message: 'Missing required fields: user_id, title, and description are required' });
    }

    // Handle checklist creation if provided
    let checklistItemIds = [];
    if (checklist && Array.isArray(checklist)) {
      // Validate that each checklist item is properly formatted
      const checklistItems = await ChecklistItem.insertMany(
        checklist.map(item => ({
          item: item.item,  // item must be a string
          completed: item.completed || false // default completed to false
        }))
      );
      checklistItemIds = checklistItems.map(item => item._id);
    }

    // Create the note first
    const note = new Note({
      user_id,
      title,
      description,
      checklists: checklistItemIds,
      is_pinned,
      reminder_time,
    });

    // Save the note and get the saved note's ID
    await note.save();

    // Handle reminder creation if reminder_time is provided
    let reminderId = null;
    if (reminder_time) {
      const reminder = new Reminder({
        user_id,
        note_id: note._id,  // Reference to the created note
        reminder_time,
      });

      // Save the reminder and associate with the note
      const savedReminder = await reminder.save();
      reminderId = savedReminder._id;
    }

    // Update the note with the reminder ID, if applicable
    if (reminderId) {
      note.reminder_id = reminderId;
      await note.save();
    }

    // Return the created note along with the reminder (if created)
    return res.status(201).json({
      message: 'Note created successfully',
      note: {
        ...note._doc,
        reminder: reminderId ? { _id: reminderId, reminder_time } : null,
      }
    });

  } catch (err) {
    console.error('Error creating note:', err);
    return res.status(500).json({ message: 'Internal Server Error', error: err.message });
  }
};



// Fetch all notes with checklists and reminders
exports.getNotes = async (req, res) => {
  try {
    const userId = req.params.userId;
    if (!userId) {
      return res.status(400).json({ error: 'User ID is required' });
    }

    const userObjectId = new mongoose.Types.ObjectId(userId);
    const notes = await Note.find({ user_id: userObjectId })
      .populate('checklists')  // Populate checklists
      .populate('reminders')  // Populate reminders
      .lean();

    if (!notes.length) {
      return res.status(404).json({ message: 'No notes found for this user' });
    }

    res.status(200).json(notes);
  } catch (err) {
    console.error('Error fetching notes:', err.message);
    res.status(500).json({ error: err.message });
  }
};

// Update an existing note

exports.updateNote = async (req, res) => {
  try {
    // Validate noteId
    const noteId = req.params.id;
    const updatedNoteData = req.body;

    // Check if the noteId is valid
    if (!mongoose.Types.ObjectId.isValid(noteId)) {
      console.log("Invalid Note ID:", noteId);
      return res.status(400).json({ message: "Invalid Note ID" });
    }

    // Find the note to be updated
    const note = await Note.findById(noteId);
    if (!note) {
      return res.status(404).json({ message: "Note not found" });
    }

    // Destructure updated data
    const { title, description, is_pinned, reminder_time, checklist } = updatedNoteData;

    // Update the note's general data
    note.title = title || note.title;
    note.description = description || note.description;
    note.is_pinned = is_pinned !== undefined ? is_pinned : note.is_pinned;

    // Handle reminder_time - update the reminder if provided
    if (reminder_time) {
      // Check if the note already has a reminder
      let reminder = await Reminder.findOne({ note_id: note._id });
      
      if (reminder) {
        // If a reminder exists, update it
        reminder.reminder_time = reminder_time;
        await reminder.save();
      } else {
        // If no reminder exists, create a new one
        reminder = new Reminder({
          user_id: note.user_id,  // Assuming user_id is available in the note
          note_id: note._id,
          reminder_time,
        });
        await reminder.save();
      }
    }

    // Handle checklist update - assuming you want to update the checklist items
    if (Array.isArray(checklist)) {
      // Insert or update checklist items as needed
      const checklistItems = await ChecklistItem.insertMany(
        checklist.map(item => ({
          item: item.item,
          completed: item.completed || false,
        }))
      );
      note.checklists = checklistItems.map(item => item._id);
    }

    // Save the updated note
    await note.save();

    // Respond with the updated note
    res.status(200).json(note);
    
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal server error', error: error.message });
  }
};





// Delete a note and its related reminders and checklists
exports.deleteNote = async (req, res) => {
  try {
    const note = await Note.findByIdAndDelete(req.params.id);
    if (!note) {
      return res.status(404).json({ error: 'Note not found' });
    }

    // Delete related reminders
    await Reminder.deleteMany({ note_id: req.params.id });

    // Delete related checklist items
    await ChecklistItem.deleteMany({ _id: { $in: note.checklists } });

    res.status(200).send(); // No content
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
