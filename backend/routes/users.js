// backend/routes/users.js

const express = require("express");
const router = express.Router();
const User = require("../models/User"); // Assurez-vous que vous avez un modèle User

// Route pour obtenir tous les utilisateurs
router.get("/", async (req, res) => {
  try {
    const users = await User.find();
    res.json(users);
  } catch (err) {
    res.status(400).send(err);
  }
});

// Route pour obtenir un utilisateur par son ID
router.get("/:id", async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    if (!user) return res.status(404).send("Utilisateur non trouvé");
    res.json(user);
  } catch (err) {
    res.status(400).send(err);
  }
});

// Route pour créer un utilisateur
router.post("/", async (req, res) => {
  const newUser = new User({
    username: req.body.username,
    email: req.body.email,
    password: req.body.password, // Assurez-vous de hasher le mot de passe en production
  });

  try {
    const savedUser = await newUser.save();
    res.status(201).json(savedUser);
  } catch (err) {
    res.status(400).send(err);
  }
});

// Route pour mettre à jour un utilisateur
router.put("/:id", async (req, res) => {
  try {
    const updatedUser = await User.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
    });
    if (!updatedUser) return res.status(404).send("Utilisateur non trouvé");
    res.json(updatedUser);
  } catch (err) {
    res.status(400).send(err);
  }
});

// Route pour supprimer un utilisateur
router.delete("/:id", async (req, res) => {
  try {
    const deletedUser = await User.findByIdAndDelete(req.params.id);
    if (!deletedUser) return res.status(404).send("Utilisateur non trouvé");
    res.json({ message: "Utilisateur supprimé" });
  } catch (err) {
    res.status(400).send(err);
  }
});

module.exports = router;
