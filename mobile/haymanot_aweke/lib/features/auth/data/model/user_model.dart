import '../../domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.name,
    required super.email,
    required super.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'email': email, 'password': password};

    if (name.isNotEmpty) {
      json['name'] = name;
    }

    return json;
  }
}