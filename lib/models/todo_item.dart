import 'todo_category.dart';

class TodoItem {
  final String id;
  final String title;
  final String description;
  final TodoCategory category;
  bool isCompleted;
  final DateTime createdAt;
  DateTime? completedAt;

  TodoItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.isCompleted = false,
    DateTime? createdAt,
    this.completedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  void toggleCompletion() {
    isCompleted = !isCompleted;
    completedAt = isCompleted ? DateTime.now() : null;
  }

  TodoItem copyWith({
    String? id,
    String? title,
    String? description,
    TodoCategory? category,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}