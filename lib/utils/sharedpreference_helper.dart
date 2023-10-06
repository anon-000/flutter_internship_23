import 'package:flutter_demo/pages/new_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data_models/user.dart';

///
/// Created by Auro on 02/10/23 at 9:53 AM
///

class SharedPreferenceHelper {
  static const TODO_KEY = 'todo';
  static const USER_KEY = 'user';

  static SharedPreferences? preferences;

  static void storeUser(User data) {
    preferences?.setString(USER_KEY, userToJson(data));
  }

  static User? get user => preferences?.getString(USER_KEY) == null
      ? null
      : userFromJson(preferences?.getString(USER_KEY) ?? '');



  static void storeToDoList(List<ToDo> data) {
    preferences?.setStringList(
      TODO_KEY,
      data.map((ToDo e) => toDoToJson(e)).toList(),
    );
  }

  static List<ToDo> get toDoList => preferences?.getStringList(TODO_KEY) == null
      ? []
      : preferences
              ?.getStringList(TODO_KEY)!
              .map((e) => toDoFromJson(e))
              .toList() ??
          [];
}
