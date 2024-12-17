import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/borrowed_book.dart';
import 'package:front/services/const.dart';

class BorrowService {
  static Future<List<BorrowedBook>> getBorrowedBooks() async {
    final response = await http.get(Uri.parse(baseUrl + "/borrows"));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => BorrowedBook.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load borrowed books');
    }
  }

  static Future<void> borrowBook(String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final response = await http.post(
      Uri.parse(baseUrl + "/borrows"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': userId, 'bookId': bookId}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to borrow book');
    }
  }

  static Future<void> markAsReturned(String borrowId) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/borrows/$borrowId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'returned': true}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark as returned');
    }
  }
}
