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
