import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_tool/models/category.dart';
import 'package:personal_tool/providers/todo_provider.dart';
import 'package:personal_tool/providers/category_provider.dart';

class TodoStatistics {
  final int totalTodos;
  final int completedTodos;
  final int incompleteTodos;
  final Map<Category, int> todosByCategory;
  final Map<Category, int> completedByCategory;

  TodoStatistics({
    required this.totalTodos,
    required this.completedTodos,
    required this.incompleteTodos,
    required this.todosByCategory,
    required this.completedByCategory,
  });

  double get completionRate => totalTodos == 0 ? 0.0 : completedTodos / totalTodos;
}

final statisticsProvider = Provider<TodoStatistics>((ref) {
  final todos = ref.watch(todoProvider);
  final categories = ref.watch(categoryProvider);

  final completedTodos = todos.where((todo) => todo.isCompleted).length;
  final incompleteTodos = todos.length - completedTodos;

  final Map<Category, int> todosByCategory = {};
  final Map<Category, int> completedByCategory = {};

  for (final category in categories) {
    final categoryTodos = todos.where((todo) => todo.category.id == category.id);
    todosByCategory[category] = categoryTodos.length;
    completedByCategory[category] = categoryTodos.where((todo) => todo.isCompleted).length;
  }

  return TodoStatistics(
    totalTodos: todos.length,
    completedTodos: completedTodos,
    incompleteTodos: incompleteTodos,
    todosByCategory: todosByCategory,
    completedByCategory: completedByCategory,
  );
});