const mongoose = require('mongoose');

const NoteSchema = new mongoose.Schema({
  user_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  title: { type: String, required: true },
  description: { type: String },
  is_pinned: { type: Boolean, default: false },
  reminder_time: { type: Date }, // Add reminder field
  created_at: { type: Date, default: Date.now },
  updated_at: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Note', NoteSchema);
