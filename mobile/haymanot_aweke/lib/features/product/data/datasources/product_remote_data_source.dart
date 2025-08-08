// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../model/Product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProductById(String id);
  Future<void> createProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  SharedPreferences sharedPreferences;

  ProductRemoteDataSourceImpl({
    required this.client,
    required this.sharedPreferences,
  });

  // Helper: Get token
  String? _getToken() {
    final token = sharedPreferences.getString('AUTH_TOKEN');
    print('Retrieved token: $token');
    return token;
  }

  // Helper: GET JSON
  Future<Map<String, dynamic>> _getJsonFromUrl(Uri url) async {
    try {
      final token = _getToken();
      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          //'Authorization': 'Bearer $token',
        },
      );
      print('GET ${url.toString()} → ${response.statusCode}');

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print('GET failed: ${response.body}');
        throw ServerException();
      }
    } catch (e) {
      print('GET error: $e');
      throw ServerException();
    }
  }

  // Helper: GET List
  Future<List<Map<String, dynamic>>> _getListFromUrl(Uri url) async {
    try {
      final token = _getToken();
      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          //'Authorization': 'Bearer $token',
        },
      );
      print('GET List ${url.toString()} → ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> jsonList = jsonResponse['data'] ?? [];
        return jsonList.map((item) => item as Map<String, dynamic>).toList();
      } else {
        print('GET list failed: ${response.body}');
        throw ServerException();
      }
    } catch (e) {
      print('GET list error: $e');
      throw ServerException();
    }
  }

  @override
  Future<void> createProduct(ProductModel product) async {
    try {
      //final token = _getToken();
      final uri = Uri.parse(
        'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products',
      );

      final request =
          http.MultipartRequest('POST', uri)
            ..fields['name'] = product.name
            ..fields['description'] = product.description
            ..fields['price'] = product.price.toString();

      // ..headers['Authorization'] = 'Bearer $token';
      if (product.imageUrl.isNotEmpty &&
          !product.imageUrl.startsWith('http') &&
          File(product.imageUrl).existsSync()) {
        final fileExtension = path.extension(product.imageUrl).toLowerCase();
        MediaType? contentType;

        switch (fileExtension) {
          case '.jpg':
          case '.jpeg':
            contentType = MediaType('image', 'jpeg');
            break;
          case '.png':
            contentType = MediaType('image', 'png');
            break;
          case '.gif':
            contentType = MediaType('image', 'gif');
            break;
          case '.webp':
            contentType = MediaType('image', 'webp');
            break;
          default:
            contentType = MediaType('image', 'jpeg');
        }

        final imageFile = await http.MultipartFile.fromPath(
          'image',
          product.imageUrl,
          contentType: contentType,
        );

        request.files.add(imageFile);
      } else {
        throw Exception('Valid image file is required');
      }
      print('Sending createProduct request to: ${uri.toString()}');
      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      print(
        'createProduct response: ${response.statusCode} → ${response.body}',
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('product created successfully');
        return;
      } else {
        throw ServerException();
      }
    } catch (e) {
      print('createProduct error: $e');
      throw ServerException();
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      final token = _getToken();
      final url = Uri.parse(
        'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/$id',
      );

      final response = await client.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          //'Authorization': 'Bearer $token',
        },
      );

      print('DELETE ${url.toString()} → ${response.statusCode}');

      if (response.statusCode != 200) {
        print('deleteProduct failed: ${response.body}');
        throw ServerException();
      }
    } catch (e) {
      print('deleteProduct error: $e');
      throw ServerException();
    }
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final url = Uri.parse(
      'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products',
    );
    final jsonList = await _getListFromUrl(url);
    return jsonList.map((jsonMap) => ProductModel.fromJson(jsonMap)).toList();
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final url = Uri.parse(
      'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/$id',
    );
    final jsonMap = await _getJsonFromUrl(url);
    final data = jsonMap['data'] as Map<String, dynamic>;
    return ProductModel.fromJson(data);
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    try {
      final token = _getToken();
      final url = Uri.parse(
        'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/${product.id}',
      );

      final body = json.encode({
        'name': product.name,
        'description': product.description,
        'price': product.price,
      });

      final response = await client.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          //'Authorization': 'Bearer $token',
        },
        body: body,
      );

      print(
        'PUT ${url.toString()} → ${response.statusCode} → ${response.body}',
      );

      if (response.statusCode != 200) {
        throw ServerException();
      }
    } catch (e) {
      print('updateProduct error: $e');
      throw ServerException();
    }
  }
}
