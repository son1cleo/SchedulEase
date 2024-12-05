const express = require('express');
const router = express.Router();
const taskController = require('../controllers/taskController');
const mongoose = require('mongoose');
const authMiddleware = require('../middleware/auth');
const taskCountController = require('../controllers/taskCountController');
const auth = require('../middleware/auth');

// Middleware to validate ObjectId parameters
const validateObjectId = (req, res, next) => {
  const { id, user_id } = req.params;
  if (id && !mongoose.Types.ObjectId.isValid(id)) {
    return res.status(400).json({ message: 'Invalid task ID' });
  }
  if (user_id && !mongoose.Types.ObjectId.isValid(user_id)) {
    return res.status(400).json({ message: 'Invalid user ID' });
  }
  next();
};

// Routes
router.get('/user/:user_id', validateObjectId, taskController.getTasks); // Get tasks by user_id
router.post('/', taskController.createTask); // Create a new task
router.put('/:id', validateObjectId, taskController.updateTask); // Update a task by id
router.delete('/:id', validateObjectId, taskController.deleteTask); // Delete a task by id


router.get('/task-count/:user_id', validateObjectId, taskCountController.getTaskCount);
router.post('/task-count', validateObjectId, taskCountController.createTaskCount);
router.put('/task-count/:userId', validateObjectId, taskCountController.updateTaskCount);


module.exports = router;


