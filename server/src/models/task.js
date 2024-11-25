const mongoose = require('mongoose');

// Checklist schema for structured items
const checklistItemSchema = new mongoose.Schema({
  item: { type: String, required: true },
  completed: { type: Boolean, default: false },
});

const taskSchema = new mongoose.Schema({
  user_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  title: { type: String, required: true },
  type: { type: String, enum: ['Checklist', 'Description'], required: true },
  details: {
    type: mongoose.Schema.Types.Mixed,
    required: true,
    validate: {
      validator: function (value) {
        if (this.type === 'Checklist') {
          return Array.isArray(value) && value.every((item) => typeof item === 'string');
        }
        if (this.type === 'Description') {
          return typeof value === 'string';
        }
        return false;
      },
      message: (props) => `Invalid details for type ${props.type}.`,
    },
  },
  schedule_date: { type: String, required: true },
  schedule_time: { type: [String], required: true },
  status: { type: String, enum: ['To-do', 'Overdue', 'Completed'], default: 'To-do' },
});

module.exports = mongoose.model('Task', taskSchema);
