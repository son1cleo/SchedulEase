const mongoose = require('mongoose');

// Checklist schema for structured items
const checklistItemSchema = new mongoose.Schema({
  item: { type: String, required: true },
  completed: { type: Boolean, default: false },
});

// Check if the model is already defined (to prevent overwriting)
module.exports = mongoose.models.ChecklistItem || mongoose.model('ChecklistItem', checklistItemSchema);