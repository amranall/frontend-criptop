import 'dart:convert';
import 'package:criptop/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Handles authentication API calls and state management.
class AuthProvider with ChangeNotifier {
  
  Map<String, dynamic> _currentUser = {};

  Map<String, dynamic> get currentUser => _currentUser;         
  /// Store the authentication token.
  String? _token;

  /// Getter for the token.
  String? get token => _token;

  /// Check if user is authenticated.
  bool get isAuthenticated => _token != null;

  /// Register a new user.
  Future<void> register(BuildContext context, String email, String password, String referralCode) async {
    final url = Uri.parse('$baseUrl/register/customer/');
    try {
      final response = await http.post(
        url,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'X-CSRFTOKEN': 'oVxetxEHD2lsT8aXd6bnm81ZmyL9qvbK1pLqIvwyxKyExshpLd8yj571sC0S8Vtq',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'referral_code': referralCode,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User registered! Please log in.')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        _handleError(context, response);
      }
    } catch (e) {
      _showSnackBar(context, 'An error occurred: $e');
    }
  }

  /// Log in an existing user.
  Future<void> login(BuildContext context, String email, String password) async {
    final url = Uri.parse('$baseUrl/login/');
    try {
      final response = await http.post(
        url,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'X-CSRFTOKEN': 'oVxetxEHD2lsT8aXd6bnm81ZmyL9qvbK1pLqIvwyxKyExshpLd8yj571sC0S8Vtq',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];

        // Save token locally
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);

        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        _handleError(context, response);
      }
    } catch (e) {
      _showSnackBar(context, 'An error occurred: $e');
    }
  }


  Future<void> claimReward(BuildContext context) async {
  final url = Uri.parse('$baseUrl/claim/');
  try {
    final response = await http.post(
      url,
      headers: {
        'accept': '*/*',
        'Authorization': 'Token $_token',
        'X-CSRFTOKEN': 'oVxetxEHD2lsT8aXd6bnm81ZmyL9qvbK1pLqIvwyxKyExshpLd8yj571sC0S8Vtq',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
      notifyListeners();
    } else {
      _handleError(context, response);
    }
  } catch (e) {
    _showSnackBar(context, 'An error occurred: $e');
  }
}

Future<void> fetchCurrentUser(BuildContext context) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/current-user/');
    try {
      final response = await http.get(
        url,
        headers: {
          'accept': '*/*',
          'Authorization': 'Token $_token', // Ensure _token is properly set
        },
      );

      if (response.statusCode == 200) {
        _currentUser = jsonDecode(response.body);
        print("current user1: $_currentUser");
        notifyListeners();
      } else {
        _handleError(context, response);
      }
    } catch (e) {
      _showSnackBar(context, 'Failed to fetch user data: $e');
    }
  }

/// Update password method.
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    final url = Uri.parse('$baseUrl/update-password/');

    try {
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Token $_token',
          'Content-Type': 'application/json',
          'X-CSRFTOKEN': 'oVxetxEHD2lsT8aXd6bnm81ZmyL9qvbK1pLqIvwyxKyExshpLd8yj571sC0S8Vtq',
        },
        body: jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Password updated successfully')),
        );
      } else {
        _handleError(context,response);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    }
  }


  /// Log out the user.
  Future<void> logout(BuildContext context) async {
    _token = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');

    notifyListeners();
    Navigator.pushReplacementNamed(context, '/login');
  }

  /// Auto-login if a token exists.
  Future<void> tryAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('auth_token')) {
      _token = prefs.getString('auth_token');
      notifyListeners();
    }
  }

  /// Handle API response errors.
  void _handleError(BuildContext context, http.Response response) {
    final errorData = jsonDecode(response.body);
    final errorMessage = errorData['detail'] ?? 'An error occurred';
    _showSnackBar(context, errorMessage);
  }

  /// Show a snack bar message.
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
