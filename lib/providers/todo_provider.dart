import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:personal_tool/models/todo.dart';
import 'package:personal_tool/models/category.dart';
import 'package:personal_tool/services/storage_service.dart';

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super([]) {
    _loadTodos();
  }

  final _uuid = const Uuid();

  Future<void> _loadTodos() async {
    final todos = await StorageService.getTodos();
    state = todos..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  Future<void> _saveTodos() async {
    await StorageService.saveTodos(state);
  }

  Future<void> addTodo(Todo todo) async {
    final newTodo = todo.copyWith(
      id: _uuid.v4(),
      sortOrder: state.length,
      createdAt: DateTime.now(),
    );
    state = [...state, newTodo];
    await _saveTodos();
  }

  Future<void> updateTodo(Todo updatedTodo) async {
    state = state
        .map((todo) => todo.id == updatedTodo.id ? updatedTodo : todo)
        .toList();
    await _saveTodos();
  }

  Future<void> deleteTodo(String id) async {
    state = state.where((todo) => todo.id != id).toList();
    await _saveTodos();
  }

  Future<void> toggleTodo(String id) async {
    state = state
        .map((todo) => todo.id == id
            ? todo.copyWith(isCompleted: !todo.isCompleted)
            : todo)
        .toList();
    await _saveTodos();
  }

  Future<void> reorderTodos(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    
    final todos = List<Todo>.from(state);
    final item = todos.removeAt(oldIndex);
    todos.insert(newIndex, item);
    
    final updatedTodos = todos
        .asMap()
        .entries
        .map((entry) => entry.value.copyWith(sortOrder: entry.key))
        .toList();
    
    state = updatedTodos;
    await _saveTodos();
  }

  List<Todo> getTodosByCategory(Category category) {
    return state.where((todo) => todo.category.id == category.id).toList();
  }

  List<Todo> getCompletedTodos() {
    return state.where((todo) => todo.isCompleted).toList();
  }

  List<Todo> getIncompleteTodos() {
    return state.where((todo) => !todo.isCompleted).toList();
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});