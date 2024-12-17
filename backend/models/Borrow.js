// models/Borrow.js
const mongoose = require('mongoose');

const BorrowSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  book: { type: mongoose.Schema.Types.ObjectId, ref: 'Book', required: true },
  borrowDate: { type: Date, default: Date.now },
  returnDate: { type: Date },
});

const Borrow = mongoose.model('Borrow', BorrowSchema);
module.exports = Borrow;
