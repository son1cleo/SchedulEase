const mongoose = require('mongoose');

const paymentSchema = new mongoose.Schema({
    user_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    amount: { type: Number, required: true },
    currency: { type: String, default: 'BDT' },
    status: { type: String, enum: ['Success', 'Failed'], required: true },
    method: { type: String, enum: ['CreditCard', 'DebitCard', 'Bkash', 'Nagad'], required: true },
    payment_date_time: { type: Date, default: Date.now },
    transaction_id: { type: String, required: true },
});

module.exports = mongoose.model('Payment', paymentSchema);
