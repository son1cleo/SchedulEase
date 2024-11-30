// noteController.js
const Note = require('../models/note');
const Reminder = require('../models/reminder');
const ChecklistItem = require('../models/checkListItem');
const mongoose = require('mongoose');

// Create a new note with checklists and reminder
exports.createNote = async (req, res) => {
  try {
    const { user_id, title, description, checklists, is_pinned, reminder_time } = req.body;

    // Handle checklist creation if provided
    let checklistItemIds = [];
    if (checklists && Array.isArray(checklists)) {
      // Correctly format the checklist item as string and boolean
      const checklistItems = await ChecklistItem.insertMany(
        checklists.map(item => ({
          item: item.item,  // item is a string
          completed: item.completed || false
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

    // Handle reminder creation if provided
    let reminderId = null;
    if (reminder_time) {
      const reminder = new Reminder({
        user_id,
        note_id: note._id,  // Now you can reference note._id after saving the note
        reminder_time,
      });
      await reminder.save();
      reminderId = reminder._id;
    }

    // If reminderId is available, add it to the note
    if (reminderId) {
      note.reminders = [reminderId];
      await note.save();  // Save the note again to add the reminder
    }

    res.status(201).json(note);
  } catch (error) {
    console.error('Error creating note:', error);
    res.status(500).json({ error: error.message });
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
    const { id } = req.params;
    const { title, description, is_pinned, reminder_time, checklists } = req.body;

    const note = await Note.findById(id);
    if (!note) {
      return res.status(404).json({ message: 'Note not found' });
    }

    // Update basic fields
    note.title = title || note.title;
    note.description = description || note.description;
    note.is_pinned = is_pinned !== undefined ? is_pinned : note.is_pinned;
    note.updated_at = new Date();

    // Handle reminder updates
    if (reminder_time) {
      let reminder = await Reminder.findOne({ note_id: id });
      if (reminder) {
        reminder.reminder_time = reminder_time;
        await reminder.save();
      } else {
        reminder = new Reminder({
          user_id: note.user_id,
          note_id: id,
          reminder_time,
        });
        await reminder.save();
      }
    } else {
      await Reminder.deleteOne({ note_id: id });
    }

    // Handle checklist updates
    if (Array.isArray(checklists)) {
      // Insert new checklist items if provided
      const newChecklistItems = checklists
        .filter((item) => !item._id && item.item) // Ensure each item has 'item' and 'completed'
        .map((item) => ({ item: item.item, completed: item.completed || false }));
      const insertedChecklistItems = await ChecklistItem.insertMany(newChecklistItems);

      // Update existing checklist items
      const existingChecklistItems = checklists.filter((item) => item._id);
      for (const checklistItem of existingChecklistItems) {
        if (checklistItem.item) {  // Ensure 'item' field is present
          await ChecklistItem.findByIdAndUpdate(checklistItem._id, {
            item: checklistItem.item,
            completed: checklistItem.completed,
          });
        } else {
          return res.status(400).json({ error: 'Item is required for checklist update' });
        }
      }

      // Combine new and existing checklist item IDs
      const allChecklistIds = [
        ...existingChecklistItems.map((item) => item._id),
        ...insertedChecklistItems.map((item) => item._id),
      ];
      note.checklists = allChecklistIds;
    }

    await note.save();

    const updatedChecklist = await ChecklistItem.find({ _id: { $in: note.checklists } });
    const reminders = await Reminder.find({ note_id: id });

    res.status(200).json({
      ...note.toObject(),
      checklist: updatedChecklist,
      reminders,
    });
  } catch (error) {
    console.error('Error updating note:', error.message);
    res.status(400).json({ message: error.message });
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
