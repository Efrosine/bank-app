class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final int? balance;

  UserModel({this.id, this.name, this.email, this.balance});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      balance: json['balance'],
    );
  }
}
