///
/// Created by Auro on 16/11/23 at 9:47 PM
///
///

// To parse this JSON data, do
//
//     final commentDatum = commentDatumFromJson(jsonString);

import 'dart:convert';

CommentDatum commentDatumFromJson(String str) =>
    CommentDatum.fromJson(json.decode(str));

String commentDatumToJson(CommentDatum data) => json.encode(data.toJson());

class CommentDatum {
  String? id;
  String? text;
  String? blog;
  CreatedBy? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  CommentDatum({
    this.id,
    this.text,
    this.blog,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory CommentDatum.fromJson(Map<String, dynamic> json) => CommentDatum(
        id: json["_id"],
        text: json["text"],
        blog: json["blog"],
        createdBy: json["createdBy"] == null
            ? null
            : CreatedBy.fromJson(json["createdBy"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "text": text,
        "blog": blog,
        "createdBy": createdBy?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class CreatedBy {
  String? id;
  String? name;
  String? email;
  String? password;
  String? phone;
  int? role;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? avatar;

  CreatedBy({
    this.id,
    this.name,
    this.email,
    this.password,
    this.phone,
    this.role,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.avatar,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        phone: json["phone"],
        role: json["role"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "role": role,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "avatar": avatar,
      };
}
