// cubits/auth_state.dart
import '../models/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;
  AuthSuccess(this.user);
}

class AuthRegistered extends AuthState {
  final User user;
  AuthRegistered(this.user);
}

class AuthError extends AuthState {
  final String message;
  final String? field;
  AuthError(this.message, [this.field]);
}

class AuthLoggedOut extends AuthState {}

class AuthValidationError extends AuthState {
  final Map<String, String> errors;
  AuthValidationError(this.errors);
}
