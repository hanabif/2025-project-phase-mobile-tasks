import '../model/Product_model.dart';


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
}
