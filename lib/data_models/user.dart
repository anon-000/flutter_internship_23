///
/// Created by Auro on 03/10/23 at 9:37 PM
///

// "{"name": "Auro", "gender": "Male"}"

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String? name;
  String? email;
  String? bio;
  String? avatar;
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
    this.bio,
    this.avatar,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    email: json["email"],
    role: json["role"],
    bio: json["bio"],
    avatar: json["avatar"],
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
    "bio": bio,
    "avatar": avatar,
    "role": role,
    "status": status,
    "_id": id,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
