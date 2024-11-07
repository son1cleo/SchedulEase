const nodemailer = require('nodemailer');
require('dotenv').config();

const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS,
    },
});

const sendResetEmail = async (to, token) => {
    const resetLink = `${process.env.CLIENT_URL}/reset-password?token=${token}`;
    await transporter.sendMail({
        from: process.env.EMAIL_USER,
        to,
        subject: 'Password Reset Request',
        text: `Click on the following link to reset your password: ${resetLink}`,
    });
};

module.exports = { sendResetEmail };
