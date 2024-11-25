// Create a new task
const mongoose = require('mongoose');
const Task = require('../models/task');
const ChecklistItem = require('../models/checklistItem');

exports.createTask = async (req, res) => {
  try {
    const { user_id, title, type, details, schedule_date, schedule_time, status } = req.body;

    // Validate required fields
    if (!Array.isArray(schedule_time) || !schedule_time.every(t => typeof t === 'string')) {
      return res.status(400).json({ message: "Invalid 'schedule_time' format. It should be an array of strings." });
    }

    let checklistItemIds = [];
    if (type === 'Checklist') {
      const checklistItems = await ChecklistItem.insertMany(details);
      checklistItemIds = checklistItems.map(item => item._id);
    }

    const task = new Task({
      user_id,
      title,
      type,
      details: type === 'Checklist' ? checklistItemIds : details, // Use `details` directly for Description type
      schedule_date,
      schedule_time,
      status,
    });


    await task.save();
    res.status(200).json(task);
  } catch (err) {
    console.error("Error creating task:", err.message);
    res.status(400).json({ message: `Failed to create task: ${err.message}` });
  }
};


// Update a task
// Update a task's status or checklist items completion
exports.updateTask = async (req, res) => {
  const { id } = req.params;
  const updates = req.body;

  // Validate ObjectId
  if (!mongoose.Types.ObjectId.isValid(id)) {
    return res.status(400).json({ message: 'Invalid task ID' });
  }

  try {
    const task = await Task.findById(id);
    if (!task) {
      return res.status(404).json({ message: 'Task not found' });
    }

    // If updating the task's overall status
    if (updates.status) {
      task.status = updates.status;
    }

    // If updating checklist item completion status
    if (updates.details && updates.type === 'Checklist') {
      // Update checklist items
      for (const item of updates.details) {
        const checklistItem = await ChecklistItem.findById(item._id);
        if (checklistItem) {
          checklistItem.completed = item.completed;  // Update completed status of checklist item
          await checklistItem.save();
        }
      }

      // Check if all checklist items are completed, then set task status to "Completed"
      const allCompleted = task.details.every(item => item.completed);
      if (allCompleted) {
        task.status = 'Completed';  // Set the task status to "Completed"
      }
    }

    // Save the updated task
    await task.save();
    res.json(task);
  } catch (err) {
    console.error("Error updating task:", err.message);
    res.status(400).json({ message: `Failed to update task: ${err.message}` });
  }
};


// Get tasks by user_id
exports.getTasks = async (req, res) => {
  const { user_id } = req.params;

  if (!mongoose.Types.ObjectId.isValid(user_id)) {
    return res.status(400).json({ message: 'Invalid user ID' });
  }

  try {
    const tasks = await Task.find({ user_id })
      .populate('details')  // Populate the details field with ChecklistItem documents
      .sort({ createdAt: -1 });
    if (tasks.length === 0) {
      return res.status(404).json({ message: 'No tasks found for this user' });
    }
    res.status(200).json(tasks);
  } catch (error) {
    console.error("Error fetching tasks:", error.message);
    res.status(500).json({ message: `Error fetching tasks: ${error.message}` });
  }
};


// Delete a task
// Delete a task and its associated checklist items if the task type is "Checklist"
exports.deleteTask = async (req, res) => {
  const { id } = req.params;

  // Validate task ID
  if (!mongoose.Types.ObjectId.isValid(id)) {
    return res.status(400).json({ message: 'Invalid task ID' });
  }

  try {
    // Find the task by ID
    const task = await Task.findById(id);
    if (!task) {
      return res.status(404).json({ message: 'Task not found' });
    }

    // If the task type is "Checklist", delete the associated checklist items
    if (task.type === 'Checklist') {
      // Assuming checklist items are stored as an array within the task's details
      for (const checklistItem of task.details) {
        await ChecklistItem.findByIdAndDelete(checklistItem._id);  // Delete each checklist item
      }
    }

    // Now, delete the task itself
    await Task.findByIdAndDelete(id);

    // Return success response
    res.json({ message: 'Task and its checklist items deleted successfully' });
  } catch (err) {
    console.error("Error deleting task:", err.message);
    res.status(500).json({ message: `Failed to delete task: ${err.message}` });
  }
};

