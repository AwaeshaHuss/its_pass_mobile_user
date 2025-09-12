class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String blockStatus;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.blockStatus,
  });

  // Factory method to create a UserModel from a Map (for API responses)
  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      blockStatus: map['blockStatus'],
    );
  }

  // Method to convert a UserModel to a Map (for API requests)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'blockStatus': blockStatus,
    };
  }
}
