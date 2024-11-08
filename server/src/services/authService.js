const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');
const { sendResetEmail } = require('../utils/emailSender');

const register = async ({ first_name, last_name, email, phone_number, password }) => {
    // Check if all fields are present
    if (!first_name || !last_name || !email || !phone_number || !password) {
        throw new Error('All fields are required');
    }
    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);
    // Create a new user with all fields
    const user = new User({
        first_name,
        last_name,
        email,
        phone_number,
        password: hashedPassword,
    });
    // Save the user to the database
    await user.save();
    return { message: 'User registered successfully' };
};

const login = async ({ email, password }) => {
    const user = await User.findOne({ email });
    if (!user || !await bcrypt.compare(password, user.password)) {
        throw new Error('Invalid email or password');
    }
    const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, { expiresIn: '1h' });
    return { token };
};

const requestPasswordReset = async (email) => {
    const user = await User.findOne({ email });
    if (!user) throw new Error('User not found');

    const resetToken = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, { expiresIn: '15m' });
    user.resetToken = resetToken;
    user.resetTokenExpiry = Date.now() + 15 * 60 * 1000; // 15 minutes from now
    await user.save();

    await sendResetEmail(email, resetToken);
    return { message: 'Password reset email sent' };
};

const resetPassword = async (token, newPassword) => {
    const payload = jwt.verify(token, process.env.JWT_SECRET);
    const user = await User.findOne({ _id: payload.userId, resetToken: token });

    if (!user || user.resetTokenExpiry < Date.now()) throw new Error('Token is invalid or expired');

    user.password = await bcrypt.hash(newPassword, 10);
    user.resetToken = null;
    user.resetTokenExpiry = null;
    await user.save();

    return { message: 'Password reset successfully' };
};

module.exports = { register, login, requestPasswordReset, resetPassword };
