import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';
import 'package:front/services/const.dart';

class BookService {

  static Future<List<Book>> getBooks() async {
    final response = await http.get(Uri.parse(baseUrl + '/books'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  static Future<void> addBook({required String title, required String author}) async {
    final response = await http.post(
      Uri.parse(baseUrl + '/books'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'author': author}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add book');
    }
  }

  static Future<void> updateBook(String bookId, {required String title, required String author}) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/books/$bookId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'author': author}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update book');
    }
  }

  static Future<void> deleteBook(String bookId) async {
    final response = await http.delete(Uri.parse('$baseUrl/books/$bookId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete book');
    }
  }
}
