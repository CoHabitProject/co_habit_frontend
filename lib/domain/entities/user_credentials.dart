class UserCredentials {
  final String username;
  final String password;

  UserCredentials({
    required this.username,
    required this.password
  });

  Map<String, dynamic> toJson() => {
    "username": this.username,
    "password": this.password
  };
}