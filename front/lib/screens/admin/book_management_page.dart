import 'package:flutter/material.dart';
import '../../models/book_model.dart';
import '../../services/book_service.dart';

class BookManagementPage extends StatefulWidget {
  @override
  _BookManagementPageState createState() => _BookManagementPageState();
}

class _BookManagementPageState extends State<BookManagementPage> {
  List<Book> books = [];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();

  Future<void> fetchBooks() async {
    books = await BookService.getBooks();
    setState(() {});
  }

  Future<void> addOrUpdateBook({String? bookId}) async {
    final title = titleController.text;
    final author = authorController.text;

    if (bookId == null) {
      await BookService.addBook(title: title, author: author);
    } else {
      await BookService.updateBook(bookId, title: title, author: author);
    }

    Navigator.pop(context);
    fetchBooks();
  }

  Future<void> deleteBook(String bookId) async {
    await BookService.deleteBook(bookId);
    fetchBooks();
  }

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.tealAccent,
        title: Text(
          'Manage Books',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Book List
            Expanded(
              child: ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      title: Text(
                        book.title,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(book.author, style: TextStyle(fontSize: 16)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.teal),
                            onPressed: () {
                              titleController.text = book.title;
                              authorController.text = book.author;
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Edit Book'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildTextField(titleController, 'Title'),
                                      _buildTextField(authorController, 'Author'),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Cancel', style: TextStyle(color: Colors.teal)),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => addOrUpdateBook(bookId: book.id),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                                      child: Text('Save'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => deleteBook(book.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Add Book Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  titleController.clear();
                  authorController.clear();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Add Book'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildTextField(titleController, 'Title'),
                          _buildTextField(authorController, 'Author'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel', style: TextStyle(color: Colors.teal)),
                        ),
                        ElevatedButton(
                          onPressed: () => addOrUpdateBook(),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                          child: Text('Add'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14), backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Add New Book', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Menu')),
            ListTile(
              title: const Text('Manage Books'),
              onTap: () {
                Navigator.pushNamed(context, '/admin/books');
              },
            ),
            ListTile(
              title: const Text('Borrowal Management'),
              onTap: () {
                Navigator.pushNamed(context, '/admin/borrowed');
              },
            ),
            ListTile(
              title: const Text('User Management'),
              onTap: () {
                Navigator.pushNamed(context, '/admin/users');
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 16, color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}
