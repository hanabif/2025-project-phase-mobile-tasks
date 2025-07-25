import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class ViewProductUsecase {
  final ProductRepository repository;

  ViewProductUsecase({required this.repository});
  Future<Either<Failure,Product?>> call(String id){
    return repository.getProductById(id);
  }
}