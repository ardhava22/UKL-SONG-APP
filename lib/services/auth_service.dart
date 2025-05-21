import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final baseUrl = 'https://dummyjson.com';

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username.trim(), // penting: buang spasi
        'password': password.trim(),
      }),
    );

    print('Login response: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'success': true,
        'data': {
          'id': data['id'],
          'username': data['username'],
          'email': data['email'],
          'firstName': data['firstName'],
          'lastName': data['lastName'],
          'gender': data['gender'],
          'image': data['image'],
        }
      };
    } else {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Unknown error'
        };
      }
    }
  }
}
