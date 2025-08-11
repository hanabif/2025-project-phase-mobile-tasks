import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';

abstract class UserLocalDatasource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCachedUser();
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
  Future<bool> isUserLoggedIn();

  Future<void> saveUserId(String userId);
  Future<String?> getUserId();
  Future<void> clearUserId();
}

class UserLocalDatasourceImpl implements UserLocalDatasource {
  final SharedPreferences sharedPreferences;
  static const String userKey = 'CACHED_USER';
  static const String tokenKey = 'AUTH_TOKEN';
  static const String userIdKey = 'USER_ID';

  UserLocalDatasourceImpl({
    required this.sharedPreferences,
    required Object client,
  });

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = json.encode(user.toJson());
      await sharedPreferences.setString(userKey, userJson);
    } catch (e) {
      throw Exception('Failed to cache user: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = sharedPreferences.getString(userKey);

      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }

      return null;
    } catch (e) {
      throw Exception('Failed to get cached user: $e');
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      await sharedPreferences.remove(userKey);
    } catch (e) {
      throw Exception('Failed to clear cached user: $e');
    }
  }

  @override
  Future<void> saveToken(String token) async {
    try {
      await sharedPreferences.setString(tokenKey, token);
    } catch (e) {
      throw Exception('Failed to save token: $e');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return sharedPreferences.getString(tokenKey);
    } catch (e) {
      throw Exception('Failed to get token: $e');
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      await sharedPreferences.remove(tokenKey);
    } catch (e) {
      throw Exception('Failed to clear token: $e');
    }
  }

  @override
  Future<void> saveUserId(String userId) async {
    try {
      await sharedPreferences.setString(userIdKey, userId);
    } catch (e) {
      throw Exception('Failed to save userId: $e');
    }
  }

  @override
  Future<String?> getUserId() async {
    try {
      return sharedPreferences.getString(userIdKey);
    } catch (e) {
      throw Exception('Failed to get userId: $e');
    }
  }

  @override
  Future<void> clearUserId() async {
    try {
      await sharedPreferences.remove(userIdKey);
    } catch (e) {
      throw Exception('Failed to clear userId: $e');
    }
  }

  @override
  Future<bool> isUserLoggedIn() async {
    try {
      final token = await getToken();
      final user = await getCachedUser();
      return token != null && user != null;
    } catch (e) {
      return false;
    }
  }
}
