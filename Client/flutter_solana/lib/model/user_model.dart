class UserModel {
  final String uid;
  final String name;
  final String email;
  final bool isAdmin;
  final String walletPublicKey;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.isAdmin,
    required this.walletPublicKey,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      isAdmin: map['isAdmin'],
      walletPublicKey: map['walletPublicKey']
          ['publicKey'], // 👈 truy cập nested
    );
  }
}
