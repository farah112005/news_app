import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';

class LocalAuthService {
  static const String usersKey = 'users_list';
  static const String currentUserKey = 'current_user_id';

  Future<List<UserModel>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(usersKey);
    if (usersJson == null) return [];
    final List decoded = jsonDecode(usersJson);
    return decoded.map((e) => UserModel.fromJson(e)).toList();
  }

  Future<void> _saveUsers(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(users.map((e) => e.toJson()).toList());
    await prefs.setString(usersKey, encoded);
  }

  String hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  Future<bool> isUserExists(String email) async {
    final users = await _getUsers();
    return users.any((u) => u.email == email);
  }

  Future<UserModel?> login(String email, String password) async {
    final users = await _getUsers();
    final user = users.firstWhereOrNull((u) => u.email == email);
    if (user == null) return null;
    final hashed = hashPassword(password, user.id);
    if (hashed == user.passwordHash) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(currentUserKey, user.id);
      return user;
    }
    return null;
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final users = await _getUsers();
    return users.firstWhereOrNull((user) => user.email == email);
  }

  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final id = const Uuid().v4();
    final hashed = hashPassword(password, id);
    final user = UserModel(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      passwordHash: hashed,
      createdAt: DateTime.now(),
    );
    final users = await _getUsers();
    users.add(user);
    await _saveUsers(users);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(currentUserKey, user.id);
    return user;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(currentUserKey);
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(currentUserKey);
    if (id == null) return null;
    final users = await _getUsers();
    return users.firstWhereOrNull((u) => u.id == id);
  }
}
