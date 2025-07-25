import '../entities/product.dart';
import '../repositories/product_repository.dart';

class UpdateProductUseCase {
  final ProductRepository repository;

  UpdateProductUseCase({required this.repository});
  
  Future<void> call(Product product) {
    return repository.updateProduct(product);
  }
}
