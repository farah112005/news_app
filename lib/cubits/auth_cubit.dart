import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user_model.dart';
import '../services/local_auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final _authService = LocalAuthService();

  Future<void> register(Map<String, dynamic> userData) async {
    emit(AuthLoading());
    try {
      await _authService.register(userData);
      final user = await _authService.getCurrentUser();
      if (user != null) {
        emit(AuthRegistered(User.fromMap(user)));
      } else {
        emit(AuthError("Failed to retrieve registered user", "register"));
      }
    } catch (e) {
      emit(AuthError(e.toString(), "register"));
    }
  }

  Future<void> login(String email, String password, bool rememberMe) async {
    emit(AuthLoading());
    try {
      final success = await _authService.login(
        email,
        password,
        rememberMe: rememberMe,
      );
      if (success) {
        final user = await _authService.getCurrentUser();
        if (user != null) {
          emit(AuthSuccess(User.fromMap(user)));
        } else {
          emit(AuthError("User not found", "login"));
        }
      } else {
        emit(AuthError("Invalid email or password", "login"));
      }
    } catch (e) {
      emit(AuthError(e.toString(), "login"));
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    emit(AuthLoggedOut());
  }

  Future<void> checkAuthStatus() async {
    final user = await _authService.getCurrentUser();
    if (user != null) {
      emit(AuthSuccess(User.fromMap(user)));
    } else {
      emit(AuthLoggedOut());
    }
  }

  Future<void> updateProfile(User updatedUser) async {
    await _authService.updateProfile(updatedUser.toMap());
    emit(AuthSuccess(updatedUser));
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    final success = await _authService.changePassword(oldPassword, newPassword);
    if (!success) {
      emit(AuthError("Old password incorrect", "changePassword"));
    } else {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        emit(AuthSuccess(User.fromMap(user)));
      }
    }
  }
}
