///
/// Created by Auro on 03/10/23 at 9:37 PM
///

// "{"name": "Auro", "gender": "Male"}"

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String? name;
  String? gender;
  String? password;

  User({
    this.name,
    this.gender,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        gender: json["gender"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "gender": gender,
        "password": password,
      };
}

/// "{"name": "Auro", "gender": "Male"}"

// final user = User(name: 'auro', gender: 'male');
//
// String a = userToJson(user);
//
// User b = userFromJson(a);
