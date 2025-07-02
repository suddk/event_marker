class AppUser {
  final String uid;
  final String phoneNumber;
  final String name;
  final String? email;
  final bool isAdmin;

  AppUser({
    required this.uid,
    required this.phoneNumber,
    required this.name,
    this.email,
    this.isAdmin = false,
  });

  factory AppUser.fromMap(Map<String, dynamic> data, String documentId) {
    return AppUser(
      uid: documentId,
      phoneNumber: data['phoneNumber'] ?? '',
      name: data['name'] ?? '',
      email: data['email'],
      isAdmin: data['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'name': name,
      'email': email,
      'isAdmin': isAdmin,
    };
  }
}
