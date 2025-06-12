import 'dart:convert';
import 'package:http/http.dart' as http;

class EventsAPI {
  // final String baseUrl = 'https://your-backend-url.com/api';
  final String baseUrl = 'http://54.165.66.148//api';

  Future<void> getAllEvents() async {
    final response = await http.get(Uri.parse('$baseUrl/all-events'));
    if (response.statusCode == 200) {
      print('GET Roles: ${response.body}');
    } else {
      print('Failed to load roles');
    }
  }

  Future<void> getEventUser(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/events/$id/user'));
    if (response.statusCode == 200) {
      print('GET Roles: ${response.body}');
    } else {
      print('Failed to load roles');
    }
  }

  Future<void> createEvent(Map<String, dynamic> roleData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create-events'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(roleData),
    );
    if (response.statusCode == 201) {
      print('Role created: ${response.body}');
    } else {
      print('Failed to create role');
    }
  }

  Future<void> updateEvent(int id, Map<String, dynamic> roleData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update-events/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(roleData),
    );
    if (response.statusCode == 200) {
      print('Role updated: ${response.body}');
    } else {
      print('Failed to update role');
    }
  }

  Future<void> deleteEvent(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete-events/$id'));
    if (response.statusCode == 200) {
      print('Role deleted');
    } else {
      print('Failed to delete role');
    }
  }
}
