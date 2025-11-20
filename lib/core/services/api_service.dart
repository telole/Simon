import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kons/core/services/auth_service.dart';

class ApiService {
  static const String baseUrl = 'https://simontrapresence.vercel.app';
  
  // Get headers with authorization token
  Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('No authentication token found. Please login again.');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Handle API response
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        // Check if response body is empty
        if (response.body.isEmpty) {
          return {'ok': true};
        }
        final decoded = json.decode(response.body);
        // Ensure 'ok' field exists for consistency
        if (decoded is Map<String, dynamic> && !decoded.containsKey('ok')) {
          decoded['ok'] = true;
        }
        return decoded;
      } catch (e) {
        // Log the actual response for debugging
        throw Exception('Invalid JSON response: ${e.toString()}\nResponse body: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}');
      }
    } else {
      // Handle error response
      try {
        // Try to parse as JSON first
        if (response.body.isNotEmpty) {
          final error = json.decode(response.body);
          final errorMsg = error['message'] ?? error['error'] ?? 'An error occurred';
          throw Exception('${errorMsg} (Status: ${response.statusCode})');
        } else {
          throw Exception('Server returned status ${response.statusCode}');
        }
      } catch (e) {
        // If not JSON, it might be HTML error page
        if (e is FormatException) {
          // Check if it's a Vercel error
          if (response.body.contains('deployment') || response.body.contains('Vercel')) {
            throw Exception('The deployment could not be found on Vercel. Please check the API URL.');
          }
          throw Exception('Server returned non-JSON response: ${response.statusCode}\nBody: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}');
        }
        rethrow;
      }
    }
  }

  // ========== PROFILE ==========
  Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/profile'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/profile'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  // ========== ATTENDANCE ==========
  Future<Map<String, dynamic>> getAttendance({String? start, String? end}) async {
    String url = '$baseUrl/api/attendance';
    if (start != null || end != null) {
      final params = <String>[];
      if (start != null) params.add('start=$start');
      if (end != null) params.add('end=$end');
      url += '?${params.join('&')}';
    }
    
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> createAttendance(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/attendance'),
        headers: await _getHeaders(),
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      // Re-throw with more context
      if (e.toString().contains('No authentication token')) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // ========== ACTIVITIES ==========
  Future<Map<String, dynamic>> getActivities({String? tanggal}) async {
    String url = '$baseUrl/api/activities';
    if (tanggal != null) {
      url += '?tanggal=$tanggal';
    }
    
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> createActivity(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/activities'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getActivity(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/activities/$id'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateActivity(String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/activities/$id'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  Future<void> deleteActivity(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/activities/$id'),
      headers: await _getHeaders(),
    );
    _handleResponse(response);
  }

  // ========== REPORTS ==========
  Future<Map<String, dynamic>> getReports({String? status}) async {
    String url = '$baseUrl/api/reports';
    if (status != null) {
      url += '?status=$status';
    }
    
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> createReport(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/reports'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getReport(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/reports/$id'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateReport(String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/reports/$id'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  Future<void> deleteReport(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/reports/$id'),
      headers: await _getHeaders(),
    );
    _handleResponse(response);
  }

  // ========== SCHEDULE ==========
  Future<Map<String, dynamic>> getSchedule({String? tanggal}) async {
    String url = '$baseUrl/api/schedule';
    if (tanggal != null) {
      url += '?tanggal=$tanggal';
    }
    
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> createSchedule(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/schedule'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateSchedule(String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/schedule/$id'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  Future<void> deleteSchedule(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/schedule/$id'),
      headers: await _getHeaders(),
    );
    _handleResponse(response);
  }
}

