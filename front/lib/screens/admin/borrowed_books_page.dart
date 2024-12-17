import 'package:flutter/material.dart';
import '../../models/borrowed_book.dart';
import '../../services/borrow_service.dart';

class AdminBorrowedBooksPage extends StatefulWidget {
  @override
  _AdminBorrowedBooksPageState createState() => _AdminBorrowedBooksPageState();
}

class _AdminBorrowedBooksPageState extends State<AdminBorrowedBooksPage> {
  List<BorrowedBook> borrowedBooks = [];

  Future<void> fetchBorrowedBooks() async {
    borrowedBooks = await BorrowService.getBorrowedBooks();
    setState(() {});
  }

  Future<void> markAsReturned(String borrowId) async {
    try {
      await BorrowService.markAsReturned(borrowId);
      fetchBorrowedBooks();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Book marked as returned')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update status')));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBorrowedBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.tealAccent,
        title: Text(
          'Borrowed Books Management',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: borrowedBooks.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: borrowedBooks.length,
                itemBuilder: (context, index) {
                  final borrow = borrowedBooks[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      title: Text(
                        borrow.bookTitle,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Borrowed by ${borrow.username}',
                        style: TextStyle(fontSize: 16),
                      ),
                      trailing: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.teal),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                        ),
                        onPressed: () => markAsReturned(borrow.id),
                        child: Text(
                          'Mark as Returned',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  );
                },
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
}
