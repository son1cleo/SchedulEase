// src/controllers/checklistController.js
const ChecklistItem = require('../models/checkListItem.js');

// Create a new checklist item
exports.createChecklistItem = async (req, res) => {
  try {
    if (!req.body.note_id || !req.body.content) {
      return res.status(400).json({ error: 'Note ID and content are required.' });
    }

    const checklistItem = new ChecklistItem({
      note_id: req.body.note_id,
      content: req.body.content,
      is_checked: req.body.is_checked || false,
    });
    await checklistItem.save();
    res.status(201).json(checklistItem);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get all checklist items for a specific note
exports.getChecklistItems = async (req, res) => {
  try {
    const checklistItems = await ChecklistItem.find({ note_id: req.params.noteId });
    res.json(checklistItems);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Update a checklist item by ID
exports.updateChecklistItem = async (req, res) => {
  try {
    const { is_checked } = req.body;
    const checklistItem = await ChecklistItem.findByIdAndUpdate(
      req.params.id,
      { is_checked, updated_at: new Date() },
      { new: true }
    );

    if (!checklistItem) {
      return res.status(404).json({ error: 'Checklist item not found' });
    }

    res.json(checklistItem);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};


// Delete a checklist item by ID
exports.deleteChecklistItem = async (req, res) => {
  try {
    const checklistItem = await ChecklistItem.findByIdAndDelete(req.params.id);
    if (!checklistItem) {
      return res.status(404).json({ error: 'Checklist item not found' });
    }
    res.status(204).send();
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};
