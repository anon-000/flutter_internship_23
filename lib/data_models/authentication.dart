///
/// Created by Auro on 07/11/23 at 10:19 PM
///

// To parse this JSON data, do
//
//     final authenticationDatum = authenticationDatumFromJson(jsonString);

import 'dart:convert';

AuthenticationDatum authenticationDatumFromJson(String str) =>
    AuthenticationDatum.fromJson(json.decode(str));

String authenticationDatumToJson(AuthenticationDatum data) =>
    json.encode(data.toJson());

class AuthenticationDatum {
  String? accessToken;
  User? user;
  bool? newUserLogin;

  AuthenticationDatum({
    this.accessToken,
    this.user,
    this.newUserLogin,
  });

  factory AuthenticationDatum.fromJson(Map<String, dynamic> json) =>
      AuthenticationDatum(
        accessToken: json["accessToken"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        newUserLogin: json["newUserLogin"],
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "user": user?.toJson(),
        "newUserLogin": newUserLogin,
      };
}

class User {
  String? name;
  String? email;
  int? role;
  int? status;
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  User({
    this.name,
    this.email,
    this.role,
    this.status,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        email: json["email"],
        role: json["role"],
        status: json["status"],
        id: json["_id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "role": role,
        "status": status,
        "_id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}
