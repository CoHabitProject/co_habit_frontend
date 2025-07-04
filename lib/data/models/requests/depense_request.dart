class DepenseRequest {
  final String title;
  final String description;
  final double amount;
  final int colocationId;
  final List<int> usersId;

  DepenseRequest(
      {required this.title,
      required this.description,
      required this.amount,
      required this.colocationId,
      required this.usersId});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'amount': amount,
      'spaceId': colocationId,
      'participantIds': usersId
    };
  }
}
