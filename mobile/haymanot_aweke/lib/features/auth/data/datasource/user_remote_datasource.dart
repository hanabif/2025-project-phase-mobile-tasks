import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/signin_model.dart';
import '../model/user_model.dart';

abstract class UserRemoteDatasource {
  Future<UserModel> signUp(UserModel user);
  Future<String> signIn(UserModel user);
}

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final http.Client client;
  static const String baseUrl =
      'https://g5-flutter-learning-path-be-tvum.onrender.com';

  UserRemoteDatasourceImpl({required this.client});

  @override
  Future<UserModel> signUp(UserModel user) async {
    try {
      print(' Attempting signup to: $baseUrl/auth/register');
      print(' Request body: ${json.encode(user.toJson())}');

      final response = await client.post(
        Uri.parse('$baseUrl/api/v2/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      print(' Response status: ${response.statusCode}');
      print(' Response body: ${response.body}');
      print(' Response headers: ${response.headers}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final userData = responseData['data'] ?? responseData;

        return UserModel(
          name: userData['name'],
          email: userData['email'],
          password: '',
        );
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Sign up failed';
        throw Exception('Sign up failed: $errorMessage');
      }
    } on FormatException catch (e) {
      print('SocketException: $e');
      throw Exception('Network error: Unable to connect to server');
    } catch (e) {
      throw Exception('Network error during sign up: $e');
    }
  }

  @override
  Future<String> signIn(UserModel user) async {
    try {
      final body = user.toJson();
      final response = await client.post(
        Uri.parse('$baseUrl/api/v2/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'applicaion/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final responseData = json.decode(response.body);
          final accessToken = responseData['data']['access_token'];
          if (accessToken == null || accessToken.toString().isEmpty) {
            throw Exception('No access token found');
          }
          return accessToken.toString();
        } catch (jsonError) {
          throw Exception('invalid JSON: $jsonError');
        }
      } else {
        try {
          final errorData = json.decode(response.body);
          final errorMessage =
              errorData['message'] ??
              errorData['error'] ??
              'sign in failed with status ${response.statusCode}';
          throw Exception('Sign in failed: $errorMessage');
        } catch (jsonError) {
          throw Exception('Sign in failed with status ${response.statusCode}');
        }
      }
    } catch (e) {
      if (e.toString().startsWith('Exception: Sign in failed:')) {
        rethrow;
      } else {
        throw Exception('Network error during sign in: $e');
      }
    }
  }
}