import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthService {
  static const String usersKey = 'users_list';
  static const String currentUserKey = 'current_user_id';
  static const String sessionKey = 'user_session';
  static const String rememberMeKey = 'remember_me';

  String hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  String _generateSalt([int length = 16]) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(
      length,
      (_) => chars[rand.nextInt(chars.length)],
    ).join();
  }

  String _generateUserId() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }

  Future<List<Map<String, dynamic>>> _getUserList(
    SharedPreferences prefs,
  ) async {
    final raw = prefs.getString(usersKey);
    if (raw == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(raw));
  }

  Future<void> register(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await _getUserList(prefs);

    if (users.any((u) => u['email'] == userData['email'])) {
      throw Exception("User already exists");
    }

    final salt = _generateSalt();
    final passwordHash = hashPassword(userData['password'], salt);

    final newUser = {
      'id': _generateUserId(),
      'firstName': userData['firstName'],
      'lastName': userData['lastName'],
      'email': userData['email'],
      'passwordHash': passwordHash,
      'salt': salt,
      'phoneNumber': userData['phoneNumber'],
      'dateOfBirth': userData['dateOfBirth']?.toIso8601String(),
      'profileImage': userData['profileImage'],
      'createdAt': DateTime.now().toIso8601String(),
      'lastLoginAt': null,
    };

    users.add(newUser);
    await prefs.setString(usersKey, jsonEncode(users));
    await prefs.setString(currentUserKey, newUser['id']);
  }

  Future<bool> login(
    String email,
    String password, {
    bool rememberMe = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await _getUserList(prefs);

    final user = users.firstWhere((u) => u['email'] == email, orElse: () => {});
    if (user.isEmpty) return false;

    final hashed = hashPassword(password, user['salt']);
    if (hashed != user['passwordHash']) return false;

    user['lastLoginAt'] = DateTime.now().toIso8601String();

    final index = users.indexWhere((u) => u['id'] == user['id']);
    users[index] = user;

    await prefs.setString(usersKey, jsonEncode(users));
    await prefs.setString(currentUserKey, user['id']);
    await prefs.setString(
      sessionKey,
      jsonEncode({
        'user_id': user['id'],
        'login_time': DateTime.now().toIso8601String(),
      }),
    );
    if (rememberMe) await prefs.setBool(rememberMeKey, true);
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(currentUserKey);
    await prefs.remove(sessionKey);
    await prefs.remove(rememberMeKey);
  }

  Future<bool> isUserExists(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await _getUserList(prefs);
    return users.any((u) => u['email'] == email);
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final users = await _getUserList(prefs);
    final id = prefs.getString(currentUserKey);
    if (id == null) return null;
    return users.firstWhere((u) => u['id'] == id, orElse: () => {});
  }

  Future<void> updateProfile(Map<String, dynamic> updatedData) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await _getUserList(prefs);
    final id = prefs.getString(currentUserKey);
    if (id == null) return;

    final index = users.indexWhere((u) => u['id'] == id);
    if (index == -1) return;

    users[index].addAll(updatedData);
    await prefs.setString(usersKey, jsonEncode(users));
  }

  Future<bool> changePassword(String oldPass, String newPass) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await _getUserList(prefs);
    final id = prefs.getString(currentUserKey);
    if (id == null) return false;

    final index = users.indexWhere((u) => u['id'] == id);
    if (index == -1) return false;

    final user = users[index];
    final oldHashed = hashPassword(oldPass, user['salt']);
    if (oldHashed != user['passwordHash']) return false;

    final newSalt = _generateSalt();
    final newHashed = hashPassword(newPass, newSalt);
    user['salt'] = newSalt;
    user['passwordHash'] = newHashed;

    users[index] = user;
    await prefs.setString(usersKey, jsonEncode(users));
    return true;
  }
}
