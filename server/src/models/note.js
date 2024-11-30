const mongoose = require('mongoose');

const NoteSchema = new mongoose.Schema({
  user_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  title: { type: String, required: true },
  description: { type: String },
  checklists: [{ type: mongoose.Schema.Types.ObjectId, ref: 'ChecklistItem' }],
  reminders: { type: mongoose.Schema.Types.ObjectId, ref: 'Reminder' }, // Adding the reminder reference here
  is_pinned: { type: Boolean, default: false },
  created_at: { type: Date, default: Date.now },
  updated_at: { type: Date },
});

module.exports = mongoose.model('Note', NoteSchema);
