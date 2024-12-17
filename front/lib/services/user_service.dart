import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'package:front/services/const.dart';

class UserService {

  static Future<List<UserModel>> getUsers() async {
    final response = await http.get(Uri.parse(baseUrl + "/users"));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<void> deleteUser(String userId) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$userId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }

  static Future<void> addUser({required String username, required String email, required String password}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'email': email, 'password': password}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add user');
    }
  }

  static Future<void> updateUser(String userId, {required String username, required String email}) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'email': email}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }
}
