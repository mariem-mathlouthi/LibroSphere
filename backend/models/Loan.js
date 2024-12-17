const mongoose = require('mongoose');

const LoanSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  bookId: { type: mongoose.Schema.Types.ObjectId, ref: 'Book', required: true },
  borrowedAt: { type: Date, default: Date.now },
});

const Loan = mongoose.model('Loan', LoanSchema);
module.exports = Loan;
