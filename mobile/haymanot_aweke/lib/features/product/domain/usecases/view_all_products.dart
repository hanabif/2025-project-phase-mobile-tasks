import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'create_product.dart';

class ViewAllProductsUsecase extends UseCase<List<Product>, Params> {
  final ProductRepository repository;

  ViewAllProductsUsecase(this.repository);

  @override
  Future<Either<Failure,List<Product>>> call(Params params) async{
    return await repository.getAllProducts();
  }
}
