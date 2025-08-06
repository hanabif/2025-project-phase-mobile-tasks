import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../model/Product_model.dart';

/// An abstract data source that defines remote operations for products.
abstract class ProductRemoteDataSource {
  /// Fetches all products from the remote source.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<ProductModel>> getAllProducts();

  /// Fetches a single product by its [id] from the remote source.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<ProductModel> getProductById(String id);

  /// Creates a new product in the remote source.

  Future<void> createProduct(ProductModel product);

  /// Updates an existing product in the remote source.
  Future<void> updateProduct(ProductModel product);

  /// Deletes a product by its [id] from the remote source.
  Future<void> deleteProduct(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ProductRemoteDataSourceImpl({required this.baseUrl, required this.client});

  // Common headers
  Map<String, String> get _headers => {'Content-Type': 'application/json'};

  // Helper for error checking
  void _handleResponse(http.Response response, {int expectedCode = 200}) {
    if (response.statusCode != expectedCode) {
      throw ServerException(
        'Status code: ${response.statusCode}, body: ${response.body}',
      );
    }
  }

  @override
  Future<void> createProduct(ProductModel product) async {
    final uri = Uri.parse('$baseUrl/api/v1/products');
    final request =
        http.MultipartRequest('POST', uri)
          ..fields['name'] = product.name
          ..fields['description'] = product.description
          ..fields['price'] = product.price.toString();

    final imageFile = File(product.imageUrl);
    if (!await imageFile.exists()) {
      throw ServerException('Image file not found: ${imageFile.path}');
    }

    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );

    final streamedResponse = await client.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    _handleResponse(response, expectedCode: 201);
  }

  @override
  Future<void> deleteProduct(String id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/api/v1/products/$id'),
      headers: _headers,
    );

    _handleResponse(response);
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final response = await client.get(
      Uri.parse('$baseUrl/api/v1/products'),
      headers: _headers,
    );
    
    _handleResponse(response);

    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    final List<dynamic> jsonList = jsonResponse['data'];
    return jsonList.map((e) => ProductModel.fromJson(e)).toList();
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/api/v1/products/$id'),
      headers: _headers,
    );

    _handleResponse(response);

    final Map<String, dynamic> jsonMap = json.decode(response.body);
    return ProductModel.fromJson(jsonMap['data']);
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    final url = Uri.parse('$baseUrl/api/v1/products/${product.id}');

    final response = await client.put(
      url,
      headers: _headers,
      body: json.encode({
        'name': product.name,
        'description': product.description,
        'price': product.price,
      }),
    );

    _handleResponse(response);
  }
}
