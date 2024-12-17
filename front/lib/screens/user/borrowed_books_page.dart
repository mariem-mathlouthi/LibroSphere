import 'package:flutter/material.dart';
import '../../models/borrowed_book.dart';
import '../../services/borrow_service.dart';

class UserBorrowedBooksPage extends StatefulWidget {
  @override
  _UserBorrowedBooksPageState createState() => _UserBorrowedBooksPageState();
}

class _UserBorrowedBooksPageState extends State<UserBorrowedBooksPage> {
  List<BorrowedBook> borrowedBooks = [];

  Future<void> fetchBorrowedBooks() async {
    borrowedBooks = await BorrowService.getBorrowedBooks();
    setState(() {});
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
        backgroundColor: Colors.blueAccent,
        title: Text('My Borrowed Books', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: borrowedBooks.isEmpty
          ? Center(child: CircularProgressIndicator())  // Loading state
          : ListView.builder(
              itemCount: borrowedBooks.length,
              itemBuilder: (context, index) {
                final borrow = borrowedBooks[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      borrow.bookId,  // Fetch actual book details if needed
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text(
                      'Borrowed on: ${borrow.borrowDate}', 
                      style: TextStyle(color: Colors.grey),
                    ),
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
