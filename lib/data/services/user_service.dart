import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserService {
  static const String usersKey = 'users_list';
  static const String loggedUserKey = 'logged_user';

  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();

    final userToSave = UserModel(
      name: user.name,
      email: user.email,
      country: user.country,
      age: user.age,
      password: user.password,
      favorites: user.favorites,
      ratings: user.ratings,
    );

    final usersJson = prefs.getStringList(usersKey) ?? [];
    final users = usersJson
        .map((json) => UserModel.fromJson(jsonDecode(json)))
        .toList();

    users.removeWhere((u) => u.email == user.email);

    users.add(userToSave);

    final updatedUsersJson = users.map((u) => jsonEncode(u.toJson())).toList();
    await prefs.setStringList(usersKey, updatedUsersJson);

    await prefs.setString(loggedUserKey, jsonEncode(userToSave.toJson()));
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(usersKey) ?? [];

    for (final json in usersJson) {
      try {
        final user = UserModel.fromJson(jsonDecode(json));
        if (user.email == email) {
          return user;
        }
      } catch (e) {
        print('Error parsing user: $e');
        continue;
      }
    }
    return null;
  }

  Future<UserModel?> getLoggedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(loggedUserKey);
    if (json != null) {
      try {
        return UserModel.fromJson(jsonDecode(json));
      } catch (e) {
        print('Error parsing logged user: $e');
        await prefs.remove(loggedUserKey);
      }
    }
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(loggedUserKey);
  }

  Future<bool> userExists(String email) async {
    return await getUserByEmail(email) != null;
  }
}
