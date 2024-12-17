// routes/borrows.js
const express = require("express");
const Borrow = require("../models/Borrow");
const Book = require("../models/Book");
const router = express.Router();

router.get("/", async (req, res) => {
  try {
    const borrowsResult = await Borrow.find().populate("user").populate("book");
    const borrows = borrowsResult
      .filter((b) => (b.returnDate ? false : true))
      .map((borrow) => ({
        _id: borrow._id,
        bookId: borrow.book._id,
        userId: borrow.user._id,
        bookTitle: borrow.book.title,
        userName: borrow.user.username,
        returnDate: borrow.returnDate,
        borrowDate: borrow.borrowDate,
        returned: true,
      }));
    res.json(borrows);
  } catch (err) {
    res.status(400).json({ message: "Error fetching borrows" });
  }
});

// Emprunter un livre
router.post("/", async (req, res) => {
  const { userId, bookId } = req.body;
  try {
    const book = await Book.findById(bookId);
    if (!book.isAvailable)
      return res.status(400).json({ message: "Book not available" });

    const borrow = new Borrow({ user: userId, book: bookId });
    await borrow.save();
    book.isAvailable = false;
    await book.save();

    res.status(201).json(borrow);
  } catch (err) {
    res.status(400).json({ message: "Error borrowing book" });
  }
});

// Retourner un livre
router.patch("/:id", async (req, res) => {
  try {
    const borrow = await Borrow.findById(req.params.id).populate("book");
    borrow.returnDate = Date.now();
    await borrow.save();

    borrow.book.isAvailable = true;
    await borrow.book.save();

    res.json(borrow);
  } catch (err) {
    res.status(400).json({ message: "Error returning book" });
  }
});

module.exports = router;
