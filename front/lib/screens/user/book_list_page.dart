import 'package:flutter/material.dart';
import '../../models/book_model.dart';
import '../../services/borrow_service.dart';
import '../../services/book_service.dart';

class BookListPage extends StatefulWidget {
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  List<Book> books = [];

  Future<void> fetchBooks() async {
    books = await BookService.getBooks();
    setState(() {});
  }

  Future<void> borrowBook(String bookId) async {
    try {
      await BorrowService.borrowBook(bookId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Book borrowed successfully')));
      fetchBooks();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to borrow book')));
    }
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
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Book List',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: books.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(book.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text(book.author),
                    trailing: book.isAvailable
                        ? ElevatedButton(
                            onPressed: () => borrowBook(book.id),
                            child: Text('Borrow'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              textStyle: TextStyle(fontSize: 16),
                            ),
                          )
                        : Text('Not Available', style: TextStyle(color: Colors.red)),
                  ),
                );
              },
            ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: const Text('My Books'),
              onTap: () {
                Navigator.pushNamed(context, '/home/books');
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
}
