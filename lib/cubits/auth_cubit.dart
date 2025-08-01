import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/local_auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LocalAuthService authService;

  AuthCubit(this.authService) : super(AuthInitial());

  Future<void> login(
    String email,
    String password, [
    bool rememberMe = false,
  ]) async {
    emit(AuthLoading());

    final user = await authService.login(email, password);
    if (user != null) {
      if (rememberMe) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('remember_me', true);
        await prefs.setString('email', email);
      }
      emit(AuthSuccess(user));
    } else {
      emit(AuthError("Invalid credentials"));
    }
  }

  Future<void> register(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    emit(AuthLoading());

    final exists = await authService.isUserExists(email);
    if (exists) {
      emit(AuthError("Email already exists"));
      return;
    }

    final user = await authService.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );

    emit(AuthSuccess(user));
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('remember_me');
    await prefs.remove('email');

    await authService.logout();
    emit(AuthLoggedOut());
  }

  Future<void> checkRememberedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final remembered = prefs.getBool('remember_me') ?? false;
    final email = prefs.getString('email');

    if (remembered && email != null) {
      final user = await authService.getUserByEmail(email);
      if (user != null) {
        emit(AuthSuccess(user));
        return;
      }
    }

    emit(AuthLoggedOut());
  }
}
