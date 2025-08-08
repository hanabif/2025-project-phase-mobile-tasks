import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/chat_entity.dart';
import '../repository/chat_repository.dart';


class GetAllChats {
  final ChatRepository repository;

  GetAllChats(this.repository);

  Future<Either<Failure, List<ChatEntity>>> call() {
    return repository.getAllChats();
  }
}
