class CreerFoyerRequest {
  final String name;
  final String adresse;
  final String ville;
  final String codePostal;

  CreerFoyerRequest(
      {required this.name,
      required this.adresse,
      required this.ville,
      required this.codePostal});

  Map<String, dynamic> toJson() => {
        'name': name,
        'city': ville,
        'address': adresse,
        'postalCode': codePostal,
      };
}
