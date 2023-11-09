///
/// Created by Auro on 07/11/23 at 10:19 PM
///

// To parse this JSON data, do
//
//     final authenticationDatum = authenticationDatumFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_demo/data_models/user.dart';

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
