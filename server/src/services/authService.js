const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');
const { sendResetEmail } = require('../utils/emailSender');

const register = async ({ email, password }) => {
    const hashedPassword = await bcrypt.hash(password, 10);
    const user = new User({ email, password: hashedPassword });
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
