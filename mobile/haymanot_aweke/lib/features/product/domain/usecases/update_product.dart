import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class UpdateProductUseCase extends UseCase<Unit, Params>{
  final ProductRepository repository;

  UpdateProductUseCase({required this.repository});
  
  @override
  Future<Either<Failure,Unit>> call(Params params)async {
    return await repository.updateProduct(params.product);
  }
}

class Params {
  final Product product;

  Params({required this.product});
}