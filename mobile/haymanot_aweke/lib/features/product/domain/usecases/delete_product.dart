import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/product_repository.dart';

class DeleteProductUsecase extends UseCase<Unit, Params>{
  final ProductRepository repository;

  DeleteProductUsecase({required this.repository});

  @override
  Future<Either<Failure,Unit>> call(Params params) async{
    return await repository.deleteProduct(params.id);
  }

}

class Params {
  final String id;

  Params({required this.id});
}