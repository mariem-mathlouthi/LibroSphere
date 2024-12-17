import 'package:flutter/material.dart';
import 'package:front/screens/admin/borrowed_books_page.dart';
import 'package:front/screens/home/admin_home.dart';
import 'package:front/screens/home/user_home.dart';
import 'screens/auth/login_page.dart';
import 'screens/auth/signup_page.dart';
import 'screens/user/book_list_page.dart';
import 'screens/admin/user_management_page.dart';
import 'screens/admin/book_management_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Bibliothèque',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => UserHomePage(),
        '/home/books': (context) => BookListPage(),
        '/admin': (context) => AdminHomePage(),
        '/admin/books': (context) => BookManagementPage(),
        '/admin/borrowed': (context) => AdminBorrowedBooksPage(),
        '/admin/users': (context) => UserManagementPage(),
      },
    );
  }
}
