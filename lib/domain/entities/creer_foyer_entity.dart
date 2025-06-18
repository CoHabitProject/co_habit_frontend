abstract class CreerFoyerEntity {
  final String name;
  final String ville;
  final String adresse;
  final String codePostal;
  final int nbPersonnes;
  final String dateEntree;

  const CreerFoyerEntity(
      {required this.name,
      required this.ville,
      required this.adresse,
      required this.codePostal,
      required this.nbPersonnes,
      required this.dateEntree});
}
