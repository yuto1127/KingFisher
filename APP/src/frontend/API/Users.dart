import 'dart:convert';
import 'package:http/http.dart' as http;

class UsersAPI {
  // final String baseUrl = 'https://your-backend-url.com/api';
  final String baseUrl = 'http://54.165.66.148//api';

  Future<void> getAllUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/all-roles'));
    if (response.statusCode == 200) {
      print('GET Roles: ${response.body}');
    } else {
      print('Failed to load roles');
    }
  }

  Future<void> createUser(Map<String, dynamic> roleData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create-users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(roleData),
    );
    if (response.statusCode == 201) {
      print('Role created: ${response.body}');
    } else {
      print('Failed to create role');
    }
  }

  Future<void> updateUser(int id, Map<String, dynamic> roleData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update-users/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(roleData),
    );
    if (response.statusCode == 200) {
      print('Role updated: ${response.body}');
    } else {
      print('Failed to update role');
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete-user/$id'));
    if (response.statusCode == 200) {
      print('Role deleted');
    } else {
      print('Failed to delete role');
    }
  }
}
