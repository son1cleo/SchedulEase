const mongoose = require('mongoose');
const ChecklistItem = require('./checklistItem');  // Import ChecklistItem model

const taskSchema = new mongoose.Schema({
  user_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  title: { type: String, required: true },
  type: { type: String, enum: ['Checklist', 'Description'], required: true },
  details: {
    type: [mongoose.Schema.Types.ObjectId],  // Array of ObjectId referencing ChecklistItem
    ref: 'ChecklistItem',  // Reference to ChecklistItem model
    required: true,
    validate: {
      validator: function (value) {
        if (this.type === 'Checklist') {
          return Array.isArray(value) && value.every(item => mongoose.Types.ObjectId.isValid(item));
        }
        if (this.type === 'Description') {
          return typeof value === 'string';
        }
        return false;
      },
      message: props => `Invalid details for type ${props.type}.`,
    },
  },
  schedule_date: { type: String, required: true },
  schedule_time: { type: [String], required: true },
  status: { type: String, enum: ['To-do', 'Overdue', 'Completed'], default: 'To-do' },
});

module.exports = mongoose.model('Task', taskSchema);
