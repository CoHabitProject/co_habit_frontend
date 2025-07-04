class ValidationService {
  static String? validateRequiredField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer $fieldName';
    }
    return null;
  }

  static String? validateCodePostalField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un code postal';
    }
    if (value.length != 5 || !RegExp(r'^\d{5}$').hasMatch(value)) {
      return 'Le code postal doit contenir 5 chiffres';
    }
    return null;
  }

  static String? validatePositiveNumbers(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer $fieldName';
    }
    int intValue = int.parse(value);
    if (intValue < 0 || intValue < 1) {
      return 'Veuillez entrer un nombre valide';
    }
    return null;
  }

  static String? validateDateField(DateTime? date) {
    if (date == null) {
      return 'Veuillez entrer une date';
    }

    return null;
  }

  static String? validateMaxCapacity(
      String? value, String fieldName, int maxCapacity) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer $fieldName';
    }

    int? intValue;
    try {
      intValue = int.parse(value);
    } catch (e) {
      return 'Veuillez entrer un nombre entier valide';
    }

    if (intValue > maxCapacity) {
      return 'La valeur maximale est $maxCapacity';
    }

    return null;
  }

  // VALIDATEURS DU FORMULAiRE D'INSCRIPTION

  static String? validatePhoneNumber(String? value) {
    if (value == null) {
      return 'Veuillez saisir un numéro de téléphone valide.';
    }
    if (value.length != 10) {
      return 'Un numéro de téléphone valide doit être composé de 10 chiffres.';
    }
    return null;
  }

  static String? validateName(String typeName, String? value) {
    if (value == null || value.trim() == '') {
      return 'Veuillez saisir un $typeName valide.';
    }
    return null;
  }

  static String? validateGender(String? value) {
    if (value == null || value.trim() == '') {
      return 'Veuillez sélectionner un sexe.';
    }

    if (value != 'Homme' && value != 'Femme') {
      return '"$value" est invalide, veuillez sélectionner une option valide.';
    }

    return null;
  }

  static String? validateBirthDate(DateTime? dateNaissance) {
    if (dateNaissance == null) {
      return 'Veuillez sélectionner votre date de naissance.';
    }
    final today = DateTime.now();
    final age = today.year -
        dateNaissance.year -
        ((today.month < dateNaissance.month ||
                (today.month == dateNaissance.month &&
                    today.day < dateNaissance.day))
            ? 1
            : 0);

    if (age < 18) {
      return 'Vous devez avoir au moins 18 ans pour vous inscrire !';
    }

    return null;
  }

  static String? validateCategoryName(
      String? value, List<String> existingLabels) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez entrer un nom de catégorie';
    }

    final trimmed = value.trim().toLowerCase();

    if (existingLabels.map((e) => e.toLowerCase()).contains(trimmed)) {
      return 'Cette catégorie existe déjà';
    }

    return null;
  }

  static String? validateDescriptionLength(String? value) {
    if (value == null) {
      return 'Veuillez entrer une description';
    }

    if (value.length < 5) {
      return 'La description doit avoir au moins 5 charactères';
    }

    return null;
  }
}
