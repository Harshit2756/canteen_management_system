/// Extension for String validation
extension StringValidation on String? {
  /// Check if the string is a valid aadhar number (12 digits)
  bool get isAadharNumber => this != null && RegExp(r'^[2-9]{1}[0-9]{11}$').hasMatch(this!);

  /// Check if string contains only letters
  bool get isAlpha => this != null && RegExp(r'^[a-zA-Z]+$').hasMatch(this!);

  /// Check if string contains only letters and numbers
  bool get isAlphanumeric => this != null && RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this!);

  /// Check if string contains only letters, numbers and spaces
  bool get isAlphanumericWithSpace => this != null && RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(this!);

  /// Check if string contains only letters and spaces
  bool get isAlphaWithSpace => this != null && RegExp(r'^[a-zA-Z\s]+$').hasMatch(this!);

  /// Check if string is valid date in format YYYY-MM-DD or mm-dd-yyyy
  bool get isDate => this != null && (RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').hasMatch(this!) || RegExp(r'^\d{2}-\d{2}-\d{4}$').hasMatch(this!));

  /// Check if string is valid email
  bool get isEmail => this != null && RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(this!);

  /// Check if string is empty
  bool get isEmptyOrNull => this?.trim().isEmpty ?? true;

  /// Check if string contains only numbers
  bool get isNumeric => this != null && RegExp(r'^[0-9]+$').hasMatch(this!);

  /// Check if string contains only numbers and spaces
  bool get isNumericWithSpace => this != null && RegExp(r'^[0-9\s]+$').hasMatch(this!);

  /// Check if string is valid Indian phone number
  bool get isPhoneNumber => this != null && RegExp(r'^(\+91[\-\s]?)?[0]?(91)?[7896]\d{9}$').hasMatch(this!);

  /// Check if string is valid password (min 8 chars, 1 uppercase, 1 lowercase, 1 number 1 special character)
  bool get isStrongPassword => this != null && RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[-@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$').hasMatch(this!);

  /// Check if string is valid URL
  bool get isURL => this != null && RegExp(r'^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$').hasMatch(this!);

  /// Validates the aadhar number format and returns an error message if invalid
  /// returns null if valid, otherwise returns an error message string
  String? validateAadharNumber() {
    if (isEmptyOrNull) {
      return 'Aadhar number is required';
    }
    if (!isAadharNumber) {
      return 'Please enter a valid Aadhar number';
    }
    return null;
  }

  /// Validates that the string contains only letters
  ///
  /// [fieldName] is used in the error message
  /// Returns null if valid, otherwise returns an error message string
  String? validateAlpha(String fieldName, {int? minLength}) {
    if (isEmptyOrNull) {
      return '$fieldName is required';
    }
    if (!isAlpha) {
      return '$fieldName must contain only letters';
    }
    if (minLength != null && this!.length < minLength) {
      return '$fieldName must be at least $minLength characters long';
    }
    return null;
  }

  /// Validates that the string contains only letters and numbers
  ///
  /// [fieldName] is used in the error message
  /// Returns null if valid, otherwise returns an error message string
  String? validateAlphanumeric(String fieldName, {int? minLength}) {
    if (isEmptyOrNull) {
      return '$fieldName is required';
    }
    if (!isAlphanumeric) {
      return '$fieldName must contain only letters and numbers';
    }
    if (minLength != null && this!.length < minLength) {
      return '$fieldName must be at least $minLength characters long';
    }
    return null;
  }

  /// Validates that the string contains only letters, numbers, and spaces
  ///
  /// [fieldName] is used in the error message
  /// Returns null if valid, otherwise returns an error message string
  String? validateAlphanumericWithSpace(String fieldName) {
    if (isEmptyOrNull) {
      return '$fieldName is required';
    }
    if (!isAlphanumericWithSpace) {
      return '$fieldName must contain only letters, numbers, and spaces';
    }
    return null;
  }

  /// Validates that the string contains only letters and spaces
  ///
  /// [fieldName] is used in the error message
  /// Returns null if valid, otherwise returns an error message string
  String? validateAlphaWithSpace(String fieldName) {
    if (isEmptyOrNull) {
      return '$fieldName is required';
    }
    if (!isAlphaWithSpace) {
      return '$fieldName must contain only letters and spaces';
    }
    return null;
  }

  /// Validates that the string is a valid date
  ///
  /// Returns null if valid, otherwise returns an error message string
  String? validateDate() {
    if (isEmptyOrNull) {
      return 'Date is required';
    }
    if (!isDate) {
      return 'Please enter a valid date';
    }
    return null;
  }

  /// Validates email format and returns an error message if invalid
  ///
  /// Returns null if valid, otherwise returns an error message string
  String? validateEmail() {
    if (isEmptyOrNull) {
      return 'Email is required';
    }
    if (!isEmail) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// validate that the string is a valid long
  ///
  /// [fieldName] is used in the error message
  ///
  String? validateLength(String fieldName, int minLength) {
    if (this!.isEmpty) {
      return 'Please enter $fieldName';
    }
    if (this!.length < minLength) {
      return '$fieldName must be at least $minLength characters long';
    }
    return null;
  }

  /// Validates that the string is not empty
  ///
  /// [fieldName] is used in the error message
  /// Returns null if valid, otherwise returns an error message string
  String? validateNotEmpty(String fieldName) {
    if (isEmptyOrNull) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates that the string contains only numbers
  ///
  /// [fieldName] is used in the error message
  /// Returns null if valid, otherwise returns an error message string
  String? validateNumeric(String fieldName) {
    if (isEmptyOrNull) {
      return '$fieldName is required';
    }
    if (!isNumeric) {
      return '$fieldName must contain only numbers';
    }
    return null;
  }

  /// Validates password strength and returns an error message if invalid
  ///
  /// Returns null if valid, otherwise returns an error message string
  ///   String? validatePassword() {
  String? validatePassword() {
    if (isEmptyOrNull) {
      return 'Password is required';
    }

    List<String> errorMessages = [];

    // Check for at least one number
    if (!RegExp(r'\d').hasMatch(this!)) {
      errorMessages.add('- must contain at least one number');
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(this!)) {
      errorMessages.add('- must contain at least one lowercase letter');
    }

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(this!)) {
      errorMessages.add('- must contain at least one uppercase letter');
    }

    // Check for minimum length
    if (this!.length < 6) {
      errorMessages.add('- must be at least 6 characters long');
    }

    // Check for at least one special character
    if (!RegExp(r'[-!@#$%^&*(),.?":{}|<>]').hasMatch(this!)) {
      errorMessages.add('- must contain at least one special character');
    }

    // Return error messages if any, otherwise return null
    return errorMessages.isNotEmpty ? 'Password must match the following criteria:\n${errorMessages.join('\n')}' : null;
  }

  /// Validates phone number format and returns an error message if invalid
  ///
  /// [format] can be 'us', 'indian', or 'international'
  /// Returns null if valid, otherwise returns an error message string
  String? validatePhoneNumber() {
    if (isEmptyOrNull) {
      return 'Phone number is required';
    }
    if (!isPhoneNumber) {
      return 'Please enter a valid Indian phone number';
    }

    return null;
  }

  /// Validates URL format and returns an error message if invalid
  ///
  /// Returns null if valid, otherwise returns an error message string
  String? validateURL() {
    if (isEmptyOrNull) {
      return 'URL is required';
    }
    if (!isURL) {
      return 'Please enter a valid URL';
    }
    return null;
  }
}
