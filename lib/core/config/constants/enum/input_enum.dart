/// Defines possible input types.
enum InputType {
  email,
  phone,
  unknown,
  empty,
}

/// A utility class for validating and identifying input types.
class InputValidator {

  static final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  static final RegExp _phoneRegex = RegExp(
    r'^\+?[0-9\s\-\(\)]{7,20}$', // Allows 7 to 20 digits, spaces, hyphens, parentheses, and optional leading +
  );

  /// Identifies the type of the given input string.
  static InputType identifyInputType(String input) {
    if (input.isEmpty) {
      return InputType.empty;
    }
    if (_emailRegex.hasMatch(input)) {
      return InputType.email;
    }
    if (_phoneRegex.hasMatch(input)) {
      return InputType.phone;
    }

    return InputType.unknown;
  }
}