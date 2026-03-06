class AppValidators {
  AppValidators._(); // Private constructor (prevent object creation)

  ///  Required Field
  static String? requiredField(String? value, {String fieldName = "Field"}) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }

  /// Email Validator
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }

    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return "Enter a valid email address";
    }

    return null;
  }

  /// Phone Validator (Indian 10 digit)
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Phone number is required";
    }

    final phoneRegex = RegExp(r'^[6-9]\d{9}$');

    if (!phoneRegex.hasMatch(value.trim())) {
      return "Enter valid 10-digit phone number";
    }

    return null;
  }

  /// Password Validator
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }

    return null;
  }

  /// Strong Password (Advanced)
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    final strongRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$',
    );

    if (!strongRegex.hasMatch(value)) {
      return "Password must contain upper, lower, number & special character";
    }

    return null;
  }

  /// 🔹 Medium Level Password
  static String? mediumPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 8) {
      return "Password must be at least 8 characters";
    }

    final upperCaseRegex = RegExp(r'[A-Z]');
    final lowerCaseRegex = RegExp(r'[a-z]');
    final numberRegex = RegExp(r'[0-9]');

    if (!upperCaseRegex.hasMatch(value)) {
      return "Password must contain at least one uppercase letter";
    }

    if (!lowerCaseRegex.hasMatch(value)) {
      return "Password must contain at least one lowercase letter";
    }

    if (!numberRegex.hasMatch(value)) {
      return "Password must contain at least one number";
    }

    return null;
  }

  /// Name Validator
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Name is required";
    }

    final trimmed = value.trim();

    if (trimmed.length < 2) {
      return "Name must be at least 2 characters";
    }

    final nameRegex = RegExp(r'^[a-zA-Z ]+$');

    if (!nameRegex.hasMatch(trimmed)) {
      return "Name can only contain letters and spaces";
    }

    return null;
  }
}
