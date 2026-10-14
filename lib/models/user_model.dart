class UserModel {
  const UserModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  final String fullName;
  final String email;
  final String phoneNumber;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    fullName: json['fullName'] as String,
    email: json['email'] as String,
    phoneNumber: json['phoneNumber'] as String,
  );

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
    'phoneNumber': phoneNumber,
  };
}
