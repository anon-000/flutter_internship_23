///
/// Created by Auro on 08/11/23 at 10:18 PM
///

// To parse this JSON data, do
//
//     final blogDatum = blogDatumFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_demo/data_models/user.dart';

BlogDatum blogDatumFromJson(String str) => BlogDatum.fromJson(json.decode(str));

String blogDatumToJson(BlogDatum data) => json.encode(data.toJson());

class BlogDatum {
  String? id;
  String? title;
  String? description;
  String? attachment;
  User? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  BlogDatum({
    this.id,
    this.title,
    this.description,
    this.attachment,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory BlogDatum.fromJson(Map<String, dynamic> json) => BlogDatum(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        attachment: json["attachment"],
        createdBy:
            json["createdBy"] == null ? null : User.fromJson(json["createdBy"]),
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
        "title": title,
        "description": description,
        "attachment": attachment,
        "createdBy": createdBy!.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}
