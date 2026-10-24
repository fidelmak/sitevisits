import 'package:equatable/equatable.dart';
import '../../domain/entity.dart';

class TaskApiModel extends Equatable {
  final List<Item> items;
  final String? nextCursor;

  const TaskApiModel({
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

  Map<String, dynamic> toJson() => {
    'items': items.map((x) => x.toJson()).toList(),
    if (nextCursor != null) 'nextCursor': nextCursor,
  };

  TaskApiModel copyWith({
    List<Item>? items,
    String? nextCursor,
  }) {
    return TaskApiModel(
      items: items ?? this.items,
      nextCursor: nextCursor ?? this.nextCursor,
    );
  }

  @override
  List<Object?> get props => [items, nextCursor];
}

class Item extends Equatable {
  final String id;
  final String title;
  final Status status;
  final DateTime updatedAt;
  final String? syncStatus;

  const Item({
    required this.id,
    required this.title,
    required this.status,
    required this.updatedAt,
    this.syncStatus,
  });

  Item copyWith({
    String? id,
    String? title,
    Status? status,
    DateTime? updatedAt,
    String? syncStatus,
    bool clearSyncStatus = false,
  }) {
    return Item(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: clearSyncStatus ? null : (syncStatus ?? this.syncStatus),
    );
  }

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json['id'] as String,
    title: (json['title'] as String?) ?? 'Untitled',
    status: Status.fromApi(json['status'] as String?),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    syncStatus: json['syncStatus'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'status': status.name,
    'updatedAt': updatedAt.toIso8601String(),
    if (syncStatus != null) 'syncStatus': syncStatus,
  };

  @override
  List<Object?> get props => [id, title, status, updatedAt, syncStatus];
}
