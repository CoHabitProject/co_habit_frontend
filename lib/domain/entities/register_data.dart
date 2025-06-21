class RegisterData {
  final String username;
  final String fullName;
  final String firstName;
  final String lastName;
  final String birthDate;
  final bool gender;
  final String phoneNumber;
  final String email;
  final String password;

  RegisterData({
    required this.username,
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.gender,
    required this.phoneNumber,
    required this.email,
    required this.password
  });

  Map<String, dynamic> toJson() => {
    "username": username,
    "fullName": fullName,
    "firstName": firstName,
    "lastName": lastName,
    "birthDate": birthDate,
    "gender": gender,
    "phoneNumber": phoneNumber,
    "email": email,
    "password": password
  };
}