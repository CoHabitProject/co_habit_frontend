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
}
