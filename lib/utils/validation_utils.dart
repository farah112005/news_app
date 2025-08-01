class ValidationUtils {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(email)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    final regex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$',
    );
    if (!regex.hasMatch(password)) {
      return 'Password must be at least 8 characters and include uppercase, lowercase, number, and symbol';
    }
    return null;
  }

  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name is required';
    }
    final regex = RegExp(r'^[A-Za-z]{2,}$');
    if (!regex.hasMatch(name)) {
      return 'Name must contain only letters and be at least 2 characters';
    }
    return null;
  }

  static String? validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) {
      return 'Phone number is required';
    }
    final regex = RegExp(r'^\+?[0-9]{7,15}$');
    if (!regex.hasMatch(phone)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  static String? validateAge(DateTime? birthDate) {
    if (birthDate == null) {
      return 'Date of birth is required';
    }
    final now = DateTime.now();
    final age = now.year - birthDate.year;
    if (age < 13) {
      return 'You must be at least 13 years old';
    }
    return null;
  }
}
