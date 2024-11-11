const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');
const { sendResetEmail } = require('../utils/emailSender');

const register = async ({ first_name, last_name, email, phone_number, password }) => {
    if (!first_name || !last_name || !email || !phone_number || !password) {
        throw new Error('All fields are required');
    }

    // Create a new user
    const user = new User({
        first_name,
        last_name,
        email,
        phone_number,
        password: password,
    });

    // Save the user to the database
    await user.save();
    console.log("User after saving:", user); // Log user after saving to ensure proper saving

    return { message: 'User registered successfully' };
};



const login = async ({ email, password }) => {
    // Find the user by email
    const user = await User.findOne({ email });
    if (!user) {
        throw new Error('Invalid email or password');
    }

    // Directly compare the raw password with the stored hash using bcrypt.compare
    const isPasswordValid = await bcrypt.compare(password, user.password);

    if (!isPasswordValid) {
        throw new Error('Invalid email or password');
    }

    // Generate a JWT token if the password is valid
    const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET);
    return { token, user: user._doc };
};




const requestPasswordReset = async (email) => {
    // Find user by email
    const user = await User.findOne({ email });
    if (!user) throw new Error('User not found');

    // Generate a reset token
    const resetToken = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, { expiresIn: '15m' });

    // Store reset token and expiry in the user model
    user.resetToken = resetToken;
    user.resetTokenExpiry = Date.now() + 15 * 60 * 1000; // 15 minutes from now
    await user.save();

    // Send the reset email with the token
    await sendResetEmail(email, resetToken);
    return { message: 'Password reset email sent' };
};


const resetPassword = async (token, newPassword) => {
    const payload = jwt.verify(token, process.env.JWT_SECRET);
    const user = await User.findOne({ _id: payload.userId, resetToken: token });

    if (!user || user.resetTokenExpiry < Date.now()) throw new Error('Token is invalid or expired');

    user.password = newPassword;
    user.resetToken = null;
    user.resetTokenExpiry = null;
    await user.save();

    return { message: 'Password reset successfully' };
};

module.exports = { register, login, requestPasswordReset, resetPassword };
