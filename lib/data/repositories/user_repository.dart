import '../models/user_model.dart';
import '../services/user_service.dart';

class UserRepository {
  final UserService _service = UserService();

  Future<void> register(UserModel user) async {
    await _service.saveUser(user);
  }

  Future<UserModel?> login(String email, String password) async {
    final user = await _service.getUserByEmail(email);

    if (user == null) return null;

    if (user.email == email && user.password == password) {
      await _service.saveUser(user);
      return user;
    }
    return null;
  }

  Future<UserModel?> getLoggedUser() async {
    return await _service.getLoggedUser();
  }

  Future<void> logout() async {
    await _service.logout();
  }

  Future<bool> emailExists(String email) async {
    return await _service.userExists(email);
  }
}
