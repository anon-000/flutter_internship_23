///
/// Created by Auro on 09/10/23 at 10:19 PM
///


// To parse this JSON data, do
//
//     final albumDatum = albumDatumFromJson(jsonString);

import 'dart:convert';

AlbumDatum albumDatumFromJson(String str) => AlbumDatum.fromJson(json.decode(str));

String albumDatumToJson(AlbumDatum data) => json.encode(data.toJson());

class AlbumDatum {
  int? userId;
  int? id;
  String? title;

  AlbumDatum({
    this.userId,
    this.id,
    this.title,
  });

  factory AlbumDatum.fromJson(Map<String, dynamic> json) => AlbumDatum(
    userId: int.parse("${json["userId"]}"),
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "title": title,
  };
}
