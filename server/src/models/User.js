const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
    first_name: { type: String, required: true },
    last_name: { type: String, required: true },
    email: { type: String, unique: true, required: true },
    phone_number: { type: String, required: true },
    password: { type: String, required: true },
    created_at: { type: Date, default: Date.now },
    subscription_status: { type: Boolean, default: false },
    resetToken: String,
    resetTokenExpiry: Date,
});

// Hash password before saving the user
userSchema.pre('save', async function (next) {
    if (!this.isModified('password')) return next();
    this.password = await bcrypt.hash(this.password, 10);
    next();
});

// Method to register user
userSchema.statics.register = async function (userData) {
    const user = new this(userData);
    return await user.save();
};

// Method to login user
userSchema.statics.login = async function (email, password) {
    const user = await this.findOne({ email });
    if (user && await bcrypt.compare(password, user.password)) {
        return user;
    }
    throw new Error('Invalid credentials');
};

// Method to reset password
userSchema.methods.resetPassword = async function (newPassword) {
    this.password = await bcrypt.hash(newPassword, 10);
    await this.save();
};

// Method to check subscription status
userSchema.methods.isSubscribe = function () {
    return this.subscription_status;
};

module.exports = mongoose.model('User', userSchema);
