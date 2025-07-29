class ValidationUtils {
  static final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final _nameRegex = RegExp(r'^[A-Za-z]{2,}$');
  static final _phoneRegex = RegExp(r'^\+?\d{10,15}$');

  static const List<String> commonPasswords = [
    '123456',
    'password',
    '123456789',
    'qwerty',
    '12345678',
  ];

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Email is required';
    if (!_emailRegex.hasMatch(email)) return 'Invalid email format';
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Include at least one uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Include at least one lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Include at least one number';
    }

    if (!RegExp(r'[!@#$%^&*()_\-+=\[\]{};:"\\|,.<>/?]').hasMatch(password)) {
      return 'Include at least one special character';
    }

    return null; // password is valid
  }

  static String? validateName(String? name) {
    if (name == null || name.isEmpty) return 'Name is required';
    if (!_nameRegex.hasMatch(name)) return 'Name must be at least 2 letters';
    return null;
  }

  static String? validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) return null;
    if (!_phoneRegex.hasMatch(phone)) return 'Invalid phone number';
    return null;
  }

  static String? validateAge(DateTime? dob) {
    if (dob == null) return null;
    final today = DateTime.now();
    final age =
        today.year -
        dob.year -
        ((today.month < dob.month ||
                (today.month == dob.month && today.day < dob.day))
            ? 1
            : 0);
    if (age < 13) return 'You must be at least 13 years old';
    return null;
  }
}
