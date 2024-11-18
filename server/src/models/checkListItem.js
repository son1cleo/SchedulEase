// src/models/checklistItem.js
const mongoose = require('mongoose');

const ChecklistItem = new mongoose.Schema({
  note_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Note', required: true },
  content: { type: String, required: true },
  is_checked: { type: Boolean, default: false },
  created_at: { type: Date, default: Date.now },
  updated_at: { type: Date },
});

module.exports = mongoose.model('ChecklistItem', ChecklistItem);
