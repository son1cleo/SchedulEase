const mongoose = require('mongoose');
const TaskCount = require('../models/task_count');

// Get the task count for a specific user
const getTaskCount = async (req, res) => {
  const { user_id } = req.params;

  if (!user_id) {
    return res.status(400).json({ message: 'User ID is required.' });
  }

  if (!mongoose.Types.ObjectId.isValid(user_id)) {
    return res.status(400).json({ message: 'Invalid user ID.' });
  }

  try {
    let taskCount = await TaskCount.findOne({ user_id });

    // If no task count is found, create a new one with a default task count of 0
    if (!taskCount) {
      taskCount = new TaskCount({ user_id, task_count: 0 });
      await taskCount.save();
    }

    res.status(200).json(taskCount);
  } catch (error) {
    console.error('Error retrieving or creating task count:', error.message);
    res.status(500).json({
      message: 'Error retrieving or creating task count.',
      error: error.message,
    });
  }
};


// Create a new task count entry for a user
const createTaskCount = async (req, res) => {
  const { userId } = req.body;

  try {
    const existingTaskCount = await TaskCount.findOne({ user_id: userId });
    if (existingTaskCount) {
      return res.status(400).json({ message: 'Task count already exists for the user.' });
    }

    const taskCount = new TaskCount({ user_id: userId });
    await taskCount.save();
    res.status(201).json({ message: 'Task count created successfully.', taskCount });
  } catch (error) {
    res.status(500).json({ message: 'Error creating task count.', error });
  }
};

// Update the task count for a specific user
const updateTaskCount = async (req, res) => {
  const { userId } = req.params;
  const { incrementBy = 1 } = req.body;

  console.log("User ID received:", userId); // Log userId
  console.log("Increment by:", incrementBy); // Log increment value

  try {
    const taskCount = await TaskCount.findOneAndUpdate(
      { user_id: userId },
      { $inc: { task_count: incrementBy } },
      { new: true }
    );

    if (!taskCount) {
      console.error("Task count not found for user:", userId); // Add logging
      return res.status(404).json({ message: 'Task count not found for the user.' });
    }

    res.status(200).json({ message: 'Task count updated successfully.', taskCount });
  } catch (error) {
    console.error("Error updating task count:", error); // Add logging
    res.status(500).json({ message: 'Error updating task count.', error });
  }
};


module.exports = {
  getTaskCount,
  createTaskCount,
  updateTaskCount,
};