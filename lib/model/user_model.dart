class UserModel {
  final String id;
  final String name;
  final String email;
  final bool isPro;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.isPro = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      isPro: json['isPro'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isPro': isPro,
    };
  }
}