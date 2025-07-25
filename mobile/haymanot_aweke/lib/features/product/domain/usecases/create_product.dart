import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class CreateProductUsecase extends UseCase<Product, Params> {
  final ProductRepository repository;

  CreateProductUsecase(this.repository);

  @override
  Future<Either<Failure, Product>> call(Params params) async {
    final result = await repository.createProduct(params.product);
    return result.fold(
      (failure) => Left(failure),
      (_) => Right(params.product),
    );
  }
}

class Params {
  final Product product;

  Params(this.product);
}