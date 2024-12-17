const express = require('express');
const Loan = require('../models/Loan');
const router = express.Router();

// Emprunter un livre
router.post('/', async (req, res) => {
  const { userId, bookId } = req.body;

  try {
    const loan = new Loan({ userId, bookId });
    await loan.save();
    await Book.findByIdAndUpdate(bookId, { isAvailable: false });
    res.status(201).json({ message: 'Livre emprunté avec succès', loan });
  } catch (err) {
    res.status(400).json({ message: 'Erreur lors de l\'emprunt du livre', error: err });
  }
});

// Consulter les livres empruntés
router.get('/:userId', async (req, res) => {
  try {
    const loans = await Loan.find({ userId: req.params.userId }).populate('bookId');
    res.json(loans);
  } catch (err) {
    res.status(400).json({ message: 'Erreur lors de la récupération des emprunts', error: err });
  }
});

module.exports = router;
