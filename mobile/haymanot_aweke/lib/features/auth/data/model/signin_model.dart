import '../../domain/entity/user_entity.dart';

class SigninModel extends UserEntity {
  const SigninModel({
    required super.email,
    required super.password,
  }) : super(name: '');

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}