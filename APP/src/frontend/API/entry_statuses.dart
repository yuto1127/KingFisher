import 'dart:convert';
import 'package:http/http.dart' as http;

class EntryStatusesAPI {
  // final String baseUrl = 'https://your-backend-url.com/api';
  final String baseUrl = 'http://54.165.66.148//api';

  Future<void> getAllEntryStatuses() async {
    final response = await http.get(Uri.parse('$baseUrl/all-entry-statuses'));
    if (response.statusCode == 200) {
      print('GET Roles: ${response.body}');
    } else {
      print('Failed to load roles');
    }
  }

  Future<void> getEntryStatusUser(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/entry-statuses/$id/user'));
    if (response.statusCode == 200) {
      print('GET Roles: ${response.body}');
    } else {
      print('Failed to load roles');
    }
  }

  Future<void> createEntryStatus(Map<String, dynamic> roleData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create-entry-statuses'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(roleData),
    );
    if (response.statusCode == 201) {
      print('Role created: ${response.body}');
    } else {
      print('Failed to create role');
    }
  }

  Future<void> updateEntryStatus(int id, Map<String, dynamic> roleData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update-entry-statuses/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(roleData),
    );
    if (response.statusCode == 200) {
      print('Role updated: ${response.body}');
    } else {
      print('Failed to update role');
    }
  }

  Future<void> deleteEntryStatus(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete-entry-statuses/$id'));
    if (response.statusCode == 200) {
      print('Role deleted');
    } else {
      print('Failed to delete role');
    }
  }
}
