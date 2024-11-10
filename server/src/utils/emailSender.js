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
    try {
        await transporter.sendMail({
            from: process.env.EMAIL_USER,
            to,
            subject: 'Password Reset Request',
            text: `Use the following token to reset your password: ${token}`,
            html: `
                <p>Hello,</p>
                <p>We received a request to reset your password. Use the token below to reset your password in the app:</p>
                <h3>${token}</h3>
                <p>Copy the token and paste it into the reset password screen in the app.</p>
                <p>If you didn’t request this, please ignore this email.</p>
            `,
        });
        console.log('Reset password email with token sent successfully.');
    } catch (error) {
        console.error('Error sending reset password email:', error);
    }
};

module.exports = { sendResetEmail };
