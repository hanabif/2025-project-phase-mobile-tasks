import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../repository/chat_repository.dart';

class SendMessageParams {
  final String chatId;
  final String content;
  final String type;
  SendMessageParams({required this.chatId, required this.content, this.type = 'text'});
}

class SendMessageUsecase extends UseCase<void, SendMessageParams> {
  final ChatRepository repo;
  SendMessageUsecase(this.repo);
  @override
  Future<Either<Failure, void>> call(SendMessageParams p) =>
      repo.sendMessage(chatId: p.chatId, content: p.content, type: p.type);
}