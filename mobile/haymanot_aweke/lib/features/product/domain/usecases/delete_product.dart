import '../repositories/product_repository.dart';

class DeleteProductUsecase{
  final ProductRepository repository;

  DeleteProductUsecase({required this.repository});

  Future<void> call(String id){
    return repository.deleteProduct(id);
  }

}