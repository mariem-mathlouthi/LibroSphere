const mongoose = require('mongoose');

const BookSchema = new mongoose.Schema({
  title: { type: String, required: true },
  author: { type: String, required: true },
  isAvailable: { type: Boolean, default: true },
});

const Book = mongoose.model('Book', BookSchema);
module.exports = Book;
