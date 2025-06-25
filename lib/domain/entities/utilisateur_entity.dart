abstract class UtilisateurEntity {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final DateTime dateDeNaissance;

  UtilisateurEntity(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.dateDeNaissance});

  String get initials =>
      "${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}";
}
