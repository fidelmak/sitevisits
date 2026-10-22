// To parse this JSON data, do
//
//     final taskApiModel = taskApiModelFromJson(jsonString);

import 'dart:convert';

TaskApiModel taskApiModelFromJson(String str) => TaskApiModel.fromJson(json.decode(str));

String taskApiModelToJson(TaskApiModel data) => json.encode(data.toJson());

class TaskApiModel {
  final List<Item> items;
  final String nextCursor;

  TaskApiModel({
    required this.items,
    required this.nextCursor,
  });

  factory TaskApiModel.fromJson(Map<String, dynamic> json) => TaskApiModel(
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    nextCursor: json["nextCursor"],
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "nextCursor": nextCursor,
  };
}

class Item {
  final String id;
  final String title;
  final Status status;
  final DateTime updatedAt;

  Item({
    required this.id,
    required this.title,
    required this.status,
    required this.updatedAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    title: json["title"],
    status: statusValues.map[json["status"]]!,
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "status": statusValues.reverse[status],
    "updatedAt": updatedAt.toIso8601String(),
  };
}

enum Status {
  DONE,
  OPEN
}

final statusValues = EnumValues({
  "done": Status.DONE,
  "open": Status.OPEN
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
