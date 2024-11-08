const express = require('express');
const authRoutes = require('./controllers/authController');
require('dotenv').config();
require('./config/db'); // Ensure database is connected on startup

const app = express();
app.use(express.json());
// app.get("/", (req, res) => {
//     res.send("This is the home page");
// });

// Use authentication routes
app.use('/auth', authRoutes);

const port = process.env.PORT || 5500;
app.listen(port, () => {
    console.log(`Server Started at http://127.0.0.1:${port}/`);
});