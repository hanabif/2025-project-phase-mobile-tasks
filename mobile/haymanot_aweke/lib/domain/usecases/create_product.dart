import '../entities/product.dart';
import '../repositories/product_repository.dart';

class CreateProductUsecase{
  final ProductRepository repository;

  CreateProductUsecase({required this.repository});

  Future<void> call(Product product){
    return repository.createProduct(product);
  }

}