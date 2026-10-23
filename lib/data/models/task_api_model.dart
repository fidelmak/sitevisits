import '../../domain/entity.dart';
class TaskApiModel {
  final List<Item> items;
  final String? nextCursor; // nullable: null means no more pages

  TaskApiModel({
    required this.items,
    this.nextCursor,
  });

  factory TaskApiModel.fromJson(Map<String, dynamic> json) => TaskApiModel(
    items: (json['items'] as List<dynamic>?)
        ?.map((x) => Item.fromJson(x as Map<String, dynamic>))
        .toList() ??
        [],
    nextCursor: json['nextCursor'] as String?,
  );

  TaskApiModel copyWith({
    List<Item>? items,
    String? nextCursor,
  }) {
    return TaskApiModel(
      items: items ?? this.items,
      nextCursor: nextCursor ?? this.nextCursor,
    );
  }
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
    id: json['id'] as String,
    title: (json['title'] as String?) ?? 'Untitled',
    status: Status.fromApi(json['status'] as String?),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );
}