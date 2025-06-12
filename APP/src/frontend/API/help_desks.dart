import 'dart:convert';
import 'package:http/http.dart' as http;

class HelpDesksAPI {
  // final String baseUrl = 'https://your-backend-url.com/api';
  final String baseUrl = 'http://54.165.66.148//api';

  Future<void> getAllHelpDesks() async {
    final response = await http.get(Uri.parse('$baseUrl/all-help-desks'));
    if (response.statusCode == 200) {
      print('GET Roles: ${response.body}');
    } else {
      print('Failed to load roles');
    }
  }

  Future<void> getHelpDeskUser(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/help-desks/$id/user'));
    if (response.statusCode == 200) {
      print('GET Roles: ${response.body}');
    } else {
      print('Failed to load roles');
    }
  }

  Future<void> createHelpDesk(Map<String, dynamic> roleData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create-help-desks'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(roleData),
    );
    if (response.statusCode == 201) {
      print('Role created: ${response.body}');
    } else {
      print('Failed to create role');
    }
  }

  Future<void> updateHelpDesk(int id, Map<String, dynamic> roleData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update-help-desks/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(roleData),
    );
    if (response.statusCode == 200) {
      print('Role updated: ${response.body}');
    } else {
      print('Failed to update role');
    }
  }

  Future<void> deleteHelpDesk(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete-help-desks/$id'));
    if (response.statusCode == 200) {
      print('Role deleted');
    } else {
      print('Failed to delete role');
    }
  }
}
