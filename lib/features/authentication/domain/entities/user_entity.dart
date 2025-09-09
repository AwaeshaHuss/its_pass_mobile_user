import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String blockStatus;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.blockStatus,
  });

  @override
  List<Object> get props => [id, name, email, phone, blockStatus];

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? blockStatus,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      blockStatus: blockStatus ?? this.blockStatus,
    );
  }
}
