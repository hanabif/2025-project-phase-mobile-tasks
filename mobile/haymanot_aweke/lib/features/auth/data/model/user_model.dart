// features/auth/data/models/user_model.dart

import '../../../chat/data/model/user_model.dart' as chat_model;
import '../../domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    super.id,
    required super.name,
    required super.email,
     super.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'], // if available
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'email': email,
      'password': password,
    };
    if (name.isNotEmpty) json['name'] = name;
    return json;
  }
  
}
extension AuthUserModelAdapter on UserModel {
  chat_model.UserModel toChatUserModel() {
    return chat_model.UserModel(
      id: '', // You can optionally fetch the actual ID from another source
      name: name,
      email: email,
    );
  }
}