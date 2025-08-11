import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase_params.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/user.dart';
import '../repository/chat_repository.dart';


class GetAllUsersUsecase extends UseCase<List<User>, NoParams> {
  final ChatRepository repo;
  GetAllUsersUsecase(this.repo);
  @override
  Future<Either<Failure, List<User>>> call(NoParams param) => repo.getAllUsers();
}