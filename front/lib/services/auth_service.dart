import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:front/services/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // local storage
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', getUserId(data['token']));

      return data['role'];
    } else {
      throw Exception('Login failed');
    }
  }

  static Future<void> signup(
      String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: json
          .encode({'username': username, 'email': email, 'password': password}),
    );

    if (response.statusCode != 201) {
      throw Exception('Signup failed');
    }
  }

  static String getUserId(String token) {
    // parse token to get user id
    final parts = token.split('.');
    String payload = parts[1];
    // while length of payload is not a multiple of 4, add '='
    while (payload.length % 4 != 0) {
      payload += '=';
    }
    print(payload);

    Codec<String, String> base64ToString = utf8.fuse(base64);
    final String decoded = base64ToString.decode(payload);
    final Map<String, dynamic> payloadMap = json.decode(decoded);
    final String userId = payloadMap['userId'];
    return userId;
  }
}
