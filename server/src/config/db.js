const mongoose = require('mongoose');
require('dotenv').config();

const connectDB = (function () {
    let instance;

    async function createConnection() {
        try {
            await mongoose.connect(process.env.MONGO_URI); // Removed deprecated options
            console.log('Connected to MongoDB');
        } catch (error) {
            console.log('Failed to connect to MongoDB', error);
        }
    }

    return {
        getInstance: function () {
            if (!instance) {
                instance = createConnection();
            }
            return instance;
        },
    };
})();

// Call `getInstance` to establish the connection
(async () => {
    await connectDB.getInstance();
})();

module.exports = connectDB;
