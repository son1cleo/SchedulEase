const mongoose = require('mongoose');

const TaskSchema = new mongoose.Schema({
  title: { type: String, required: true },
  type: { type: String, enum: ['Description', 'Checklist'], required: true },
  details: { type: mongoose.Schema.Types.Mixed, required: true }, // String or Array
  schedule_date: { type: String, required: true }, // Format: YYYY-MM-DD
  schedule_time: { type: [String], required: true }, // Array of times
  status: { type: String, enum: ['To-do', 'Completed', 'Overdue'], default: 'To-do' },
});

module.exports = mongoose.model('Task', TaskSchema);
