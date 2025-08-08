import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['_id'], name: json['name'], email: json['email']);
  }

  Map<String, dynamic> toJson() => {'_id': id, 'name': name, 'email': email};

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(name: entity.name, email: entity.email, id: entity.id);
  }
  UserEntity toEntity() {
    return UserEntity(name: name, email: email, id: id);
  }
}
