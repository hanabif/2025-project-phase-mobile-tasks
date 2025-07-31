import 'dart:convert';

import 'package:haymanot_aweke/features/product/data/model/Product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';

abstract class ProductLocalDataSource {
  /// Retrieves the last cached list of products from local storage.
  ///
  /// Throws a [CacheException] if no cached data is present.
  Future<List<ProductModel>> getLastProductList();

  /// Retrieves a single product by its [id] from local storage.
  ///
  /// Throws a [CacheException] if the product is not found.
  Future<ProductModel> getProductById(String id);

  /// Caches a list of products to local storage.
  ///
  /// Throws a [CacheException] if caching fails.
  Future<void> cacheProductList(List<ProductModel> products);

  /// Caches a single product to local storage.
  ///
  /// Throws a [CacheException] if caching fails.
  Future<void> cacheProduct(ProductModel product);

  /// Deletes a cached product by ID.
  Future<void> deleteProduct(String id);
}

const CACHED_PRODUCT_LIST = 'CACHED_PRODUCT_LIST';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;
  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheProduct(ProductModel product) async {
    final jsonString = sharedPreferences.getString('CACHED_PRODUCT_LIST');
    List<ProductModel> currentList = [];

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      currentList =
          jsonList.map((item) => ProductModel.fromJson(item)).toList();
    }

    currentList.removeWhere((p) => p.id == product.id);

    currentList.add(product);

    final updatedJson = json.encode(
      currentList.map((p) => p.toJson()).toList(),
    );

    await sharedPreferences.setString('CACHED_PRODUCT_LIST', updatedJson);
  }

  @override
  Future<void> cacheProductList(List<ProductModel> products) {
    final jsonString = json.encode(products.map((p) => p.toJson()).toList());
    return sharedPreferences.setString('CACHED_PRODUCT_LIST', jsonString);
  }

  @override
  Future<void> deleteProduct(String id) async {
    final jsonString = sharedPreferences.getString('CACHED_PRODUCT_LIST');

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      final List<ProductModel> currentList =
          jsonList.map((item) => ProductModel.fromJson(item)).toList();

      final updatedList =
          currentList.where((product) => product.id != id).toList();

      final updatedJson = json.encode(
        updatedList.map((product) => product.toJson()).toList(),
      );

      await sharedPreferences.setString('CACHED_PRODUCT_LIST', updatedJson);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<List<ProductModel>> getLastProductList() {
    final jsonString = sharedPreferences.getString(CACHED_PRODUCT_LIST);

    if (jsonString != null) {
      final List<dynamic> decodedJson = json.decode(jsonString);
      final List<ProductModel> productList =
          decodedJson
              .map(
                (item) => ProductModel.fromJson(item as Map<String, dynamic>),
              )
              .toList();
      return Future.value(productList);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<ProductModel> getProductById(String id) {
    final jsonString = sharedPreferences.getString('CACHED_PRODUCT_LIST');

    if (jsonString != null) {
      final List<dynamic> decodedList = json.decode(jsonString);

      try {
        final productMap = decodedList.firstWhere(
          (item) => item['id'] == id,
          orElse: () => throw CacheException(),
        );

        return Future.value(ProductModel.fromJson(productMap));
      } catch (e) {
        throw CacheException();
      }
    } else {
      throw CacheException();
    }
  }
}
