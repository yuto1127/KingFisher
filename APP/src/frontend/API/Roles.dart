import 'dart:convert';
import 'package:http/http.dart' as http;

class RolesAPI {
  // final String baseUrl = 'https://your-backend-url.com/api';
  final String baseUrl = 'http://44.211.190.194/api';

  Future<void> getRoles() async {
    final response = await http.get(Uri.parse('$baseUrl/roles'));
    if (response.statusCode == 200) {
      print('GET Roles: ${response.body}');
    } else {
      print('Failed to load roles');
    }
  }

  Future<void> createRole(Map<String, dynamic> roleData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/roles'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(roleData),
    );
    if (response.statusCode == 201) {
      print('Role created: ${response.body}');
    } else {
      print('Failed to create role');
    }
  }

  Future<void> updateRole(int id, Map<String, dynamic> roleData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/roles/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(roleData),
    );
    if (response.statusCode == 200) {
      print('Role updated: ${response.body}');
    } else {
      print('Failed to update role');
    }
  }

  Future<void> deleteRole(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/roles/$id'));
    if (response.statusCode == 200) {
      print('Role deleted');
    } else {
      print('Failed to delete role');
    }
  }
}
