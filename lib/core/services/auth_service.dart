import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _tokenKey = 'supabase_access_token';
  static const String _supabaseUrlKey = 'supabase_url';
  static const String _supabaseAnonKeyKey = 'supabase_anon_key';
  
  static const String defaultSupabaseUrl = 'https://uqcvuqgxiczpgemskaix.supabase.co';
  static const String defaultSupabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVxY3Z1cWd4aWN6cGdlbXNrYWl4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM1NTMxMDYsImV4cCI6MjA3OTEyOTEwNn0.yyKbkrmOG98a9-lelbKOQ3j-azDR7ZRPAJFogWsfN5I';

  // Get Supabase URL
  static Future<String> getSupabaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_supabaseUrlKey) ?? defaultSupabaseUrl;
  }

  // Get Supabase Anon Key
  static Future<String> getSupabaseAnonKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_supabaseAnonKeyKey) ?? defaultSupabaseAnonKey;
  }

  // Set Supabase credentials
  static Future<void> setSupabaseCredentials(String url, String anonKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_supabaseUrlKey, url);
    await prefs.setString(_supabaseAnonKeyKey, anonKey);
  }

  // Register/Signup with Supabase
  static Future<Map<String, dynamic>> signup(String email, String password, {String? username}) async {
    final supabaseUrl = await getSupabaseUrl();
    final anonKey = await getSupabaseAnonKey();
    
    final response = await http.post(
      Uri.parse('$supabaseUrl/auth/v1/signup'),
      headers: {
        'apikey': anonKey,
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
        'data': username != null ? {'username': username} : null,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      // Check if user needs email confirmation
      if (data['user'] != null) {
        // If email confirmation is required, user might not get access_token immediately
        if (data['access_token'] != null) {
          await saveToken(data['access_token']);
          return {'ok': true, 'access_token': data['access_token'], 'user': data['user']};
        } else {
          // Email confirmation required
          return {'ok': true, 'user': data['user'], 'requires_confirmation': true};
        }
      } else {
        throw Exception('Registration failed: No user data received');
      }
    } else {
      try {
        final error = json.decode(response.body);
        throw Exception(error['error_description'] ?? error['message'] ?? 'Registration failed');
      } catch (e) {
        throw Exception('Registration failed: ${response.statusCode}');
      }
    }
  }

  // Login with Supabase
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final supabaseUrl = await getSupabaseUrl();
    final anonKey = await getSupabaseAnonKey();
    
    final response = await http.post(
      Uri.parse('$supabaseUrl/auth/v1/token?grant_type=password'),
      headers: {
        'apikey': anonKey,
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final accessToken = data['access_token'];
      
      if (accessToken != null) {
        await saveToken(accessToken);
        return {'ok': true, 'access_token': accessToken};
      } else {
        throw Exception('No access token received');
      }
    } else {
      try {
        final error = json.decode(response.body);
        throw Exception(error['error_description'] ?? error['message'] ?? 'Login failed');
      } catch (e) {
        throw Exception('Login failed: ${response.statusCode}');
      }
    }
  }

  // Save token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}

