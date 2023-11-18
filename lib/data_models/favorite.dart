///
/// Created by Auro on 18/11/23 at 10:15 PM
///

// To parse this JSON data, do
//
//     final favoriteDatum = favoriteDatumFromJson(jsonString);

import 'dart:convert';

FavoriteDatum favoriteDatumFromJson(String str) =>
    FavoriteDatum.fromJson(json.decode(str));

String favoriteDatumToJson(FavoriteDatum data) => json.encode(data.toJson());

class FavoriteDatum {
  String? id;
  String? blog;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  FavoriteDatum({
    this.id,
    this.blog,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory FavoriteDatum.fromJson(Map<String, dynamic> json) => FavoriteDatum(
        id: json["_id"],
        blog: json["blog"],
        createdBy: json["createdBy"],
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
        "blog": blog,
        "createdBy": createdBy,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}
