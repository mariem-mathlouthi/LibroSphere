const express = require("express");
const Book = require("../models/Book");
const router = express.Router();

// Obtenir la liste des livres
router.get("/", async (req, res) => {
  try {
    const books = await Book.find();
    res.json(books);
  } catch (err) {
    res.status(400).json({ message: "Error fetching books" });
  }
});

// Ajouter un livre
router.post("/", async (req, res) => {
  const { title, author } = req.body;
  const newBook = new Book({ title, author });
  try {
    await newBook.save();
    res.status(201).json(newBook);
  } catch (err) {
    res.status(400).json({ message: "Error adding book" });
  }
});

// Mettre à jour la disponibilité d'un livre
router.patch("/:id", async (req, res) => {
  try {
    const book = await Book.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
    });
    res.json(book);
  } catch (err) {
    res.status(400).json({ message: "Error updating book" });
  }
});

// Supprimer un livre
router.delete("/:id", async (req, res) => {
  try {
    await Book.findByIdAndDelete(req.params.id);
    res.json({ message: "Book deleted successfully" });
  } catch (err) {
    res.status(400).json({ message: "Error deleting book" });
  }
});

module.exports = router;
