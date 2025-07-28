import './category.dart';
import './tag.dart';

class Todo {
  final String id;
  final String title;
  final String description;
  final Category category;
  final List<Tag> tags;
  final bool isCompleted;
  final DateTime createdAt;
  final int sortOrder;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.tags,
    required this.isCompleted,
    required this.createdAt,
    required this.sortOrder,
  });

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    Category? category,
    List<Tag>? tags,
    bool? isCompleted,
    DateTime? createdAt,
    int? sortOrder,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.toJson(),
      'tags': tags.map((tag) => tag.toJson()).toList(),
      'isCompleted': isCompleted,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'sortOrder': sortOrder,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: Category.fromJson(json['category']),
      tags: (json['tags'] as List)
          .map((tagJson) => Tag.fromJson(tagJson))
          .toList(),
      isCompleted: json['isCompleted'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      sortOrder: json['sortOrder'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Todo && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
