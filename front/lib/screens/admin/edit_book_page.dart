import 'package:flutter/material.dart';
import '../../services/book_service.dart';
import '../../models/book_model.dart';

class EditBookPage extends StatefulWidget {
  final Book? book;

  EditBookPage({this.book});

  @override
  _EditBookPageState createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _bookService = BookService();

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _titleController.text = widget.book!.title;
      _authorController.text = widget.book!.author;
    }
  }

  void _saveBook() async {
    if (_titleController.text.isEmpty || _authorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    final book = Book(
      id: widget.book?.id ?? '',  // Utiliser une valeur par défaut pour 'id'
      title: _titleController.text,
      author: _authorController.text,
      isAvailable: widget.book?.isAvailable ?? true,
    );

    try {
      await BookService.updateBook(book.id, title: book.title, author: book.author);
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'enregistrement du livre')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          widget.book == null ? 'Ajouter un livre' : 'Modifier un livre',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Titre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.teal),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.tealAccent),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: 'Auteur',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.teal),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.tealAccent),
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveBook,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.teal),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                ),
              ),
              child: Text(
                widget.book == null ? 'Ajouter' : 'Modifier',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
