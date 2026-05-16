/// A collection of [TextFormField] validators for common form fields.
/// Usage: validator: Validators.name
class Validators {
  Validators._(); // Prevent instantiation

  // ---------------------------------------------------------------------------
  // Name
  // ---------------------------------------------------------------------------

  /// Validates a full name.
  /// - Must not be empty.
  /// - Only letters, spaces, hyphens, and apostrophes are allowed.
  /// - Must be at least 2 characters long.
  static String? name(String? value) {
    final v = value?.trim() ?? '';

    if (v.isEmpty) return 'Name is required.';
    if (v.length < 2) return 'Name must be at least 2 characters.';

    final nameRegex = RegExp(r"^[a-zA-Z\s'\-]+$");
    if (!nameRegex.hasMatch(v)) {
      return 'Name can only contain letters, spaces, hyphens, or apostrophes.';
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // India Phone Number
  // ---------------------------------------------------------------------------

  /// Validates an Indian mobile number.
  /// - Must not be empty.
  /// - Optional leading +91 or 0 prefix.
  /// - Must be a 10-digit number starting with 6, 7, 8, or 9.
  static String? phone(String? value) {
    final v = value?.trim() ?? '';

    if (v.isEmpty) return 'Phone number is required.';

    // Strip optional country code prefix (+91 or 91 or 0)
    final stripped = v.replaceFirst(RegExp(r'^(\+91|91|0)'), '');

    final phoneRegex = RegExp(r'^[6-9]\d{9}$');
    if (!phoneRegex.hasMatch(stripped)) {
      return 'Enter a valid 10-digit Indian mobile number.';
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // Email
  // ---------------------------------------------------------------------------

  /// Validates an email address.
  /// - Must not be empty.
  /// - Must follow standard email format (local@domain.tld).
  static String? email(String? value) {
    final v = value?.trim() ?? '';

    if (v.isEmpty) return 'Email is required.';

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(v)) {
      return 'Enter a valid email address.';
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // Password
  // ---------------------------------------------------------------------------

  /// Validates a password with the following rules:
  /// - Must not be empty.
  /// - Minimum 6 characters long.
  /// - Must contain at least one uppercase letter (A–Z).
  /// - Must contain at least one digit (0–9).
  static String? password(String? value) {
    final v = value ?? '';

    if (v.isEmpty) return 'Password is required.';
    if (v.length < 6) return 'Password must be at least 6 characters.';
    if (!RegExp(r'[A-Z]').hasMatch(v)) {
      return 'Password must contain at least one uppercase letter.';
    }
    if (!RegExp(r'[0-9]').hasMatch(v)) {
      return 'Password must contain at least one number.';
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // Confirm Password
  // ---------------------------------------------------------------------------

  /// Validates that [confirmValue] matches [originalPassword].
  /// Use this as a closure in your form:
  ///   validator: (val) => Validators.confirmPassword(val, _passwordController.text)
  static String? confirmPassword(
    String? confirmValue,
    String originalPassword,
  ) {
    final v = confirmValue ?? '';

    if (v.isEmpty) return 'Please confirm your password.';
    if (v != originalPassword) return 'Passwords do not match.';

    return null;
  }
}
