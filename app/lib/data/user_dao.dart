import '../models/user_model.dart';
import 'database_helper.dart';

class UserDao {
  Future<int> insertUser(UserModel user) async {
    final db = await DatabaseHelper.instance.database;

    return db.insert(
      'users',
      user.toMap(),
    );
  }

  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return UserModel.fromMap(result.first);
  }

  Future<UserModel?> findByEmail(String email) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return UserModel.fromMap(result.first);
  }
}