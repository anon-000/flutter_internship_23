import 'package:flutter_demo/pages/new_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
/// Created by Auro on 02/10/23 at 9:53 AM
///

class SharedPreferenceHelper {
  static const TODO_KEY = 'todo';

  static SharedPreferences? preferences;

  static void storeToDoList(List<ToDo> data) {
    preferences?.setStringList(
      TODO_KEY,
      data.map((e) => toDoToJson(e)).toList(),
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
