import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';

class HiveService {
  static const String _userBox = 'userBox';

  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter<User>(UserAdapter());
    await Hive.openBox<User>(_userBox);
  }

  Future<void> addUser(User user) async {
    final box = await Hive.openBox<User>(_userBox);
    await box.add(user);
  }

  Future<User?> getUser(String username) async {
    final box = await Hive.openBox<User>(_userBox);
    final users = box.values.toList();
    for (final user in users) {
      if (user.username == username) {
        return user;
      }
    }
    return null;
  }
}
