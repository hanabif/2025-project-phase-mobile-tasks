import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase_params.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/chat_entity.dart';
import '../entities/chat_message_entity.dart';
import '../entities/user.dart';
import '../repository/chat_repository.dart';


class GetMyChatsUsecase extends UseCase<List<Chat>, NoParams> {
  final ChatRepository repo;
  GetMyChatsUsecase(this.repo);
  @override
  Future<Either<Failure, List<Chat>>> call(NoParams params) => repo.getMyChats();
}
