import 'package:flutter_test/flutter_test.dart';
import 'package:personal_tool/models/todo_item.dart';
import 'package:personal_tool/models/todo_category.dart';

void main() {
  group('TodoItem', () {
    test('should create a TodoItem with required fields', () {
      final todo = TodoItem(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        category: TodoCategory.flexMuscles,
      );

      expect(todo.id, '1');
      expect(todo.title, 'Test Task');
      expect(todo.description, 'Test Description');
      expect(todo.category, TodoCategory.flexMuscles);
      expect(todo.isCompleted, false);
      expect(todo.completedAt, null);
      expect(todo.createdAt, isNotNull);
    });

    test('should create a TodoItem with completed state', () {
      final todo = TodoItem(
        id: '2',
        title: 'Completed Task',
        description: 'Completed Description',
        category: TodoCategory.displayVulnerability,
        isCompleted: true,
      );

      expect(todo.isCompleted, true);
      expect(todo.completedAt, null); // completedAt is null until toggleCompletion is called
    });

    test('should toggle completion status', () {
      final todo = TodoItem(
        id: '3',
        title: 'Toggle Task',
        description: 'Toggle Description',
        category: TodoCategory.flexMuscles,
      );

      expect(todo.isCompleted, false);
      expect(todo.completedAt, null);

      // Toggle to completed
      todo.toggleCompletion();
      expect(todo.isCompleted, true);
      expect(todo.completedAt, isNotNull);

      // Toggle back to incomplete
      todo.toggleCompletion();
      expect(todo.isCompleted, false);
      expect(todo.completedAt, null);
    });

    test('should create a copy with modified fields', () {
      final originalTodo = TodoItem(
        id: '4',
        title: 'Original Task',
        description: 'Original Description',
        category: TodoCategory.flexMuscles,
      );

      final copiedTodo = originalTodo.copyWith(
        title: 'Modified Task',
        category: TodoCategory.displayVulnerability,
        isCompleted: true,
      );

      expect(copiedTodo.id, '4'); // unchanged
      expect(copiedTodo.title, 'Modified Task'); // changed
      expect(copiedTodo.description, 'Original Description'); // unchanged
      expect(copiedTodo.category, TodoCategory.displayVulnerability); // changed
      expect(copiedTodo.isCompleted, true); // changed
      expect(copiedTodo.createdAt, originalTodo.createdAt); // unchanged
    });

    test('should create a copy with same fields when no changes provided', () {
      final originalTodo = TodoItem(
        id: '5',
        title: 'Same Task',
        description: 'Same Description',
        category: TodoCategory.flexMuscles,
        isCompleted: true,
      );

      final copiedTodo = originalTodo.copyWith();

      expect(copiedTodo.id, originalTodo.id);
      expect(copiedTodo.title, originalTodo.title);
      expect(copiedTodo.description, originalTodo.description);
      expect(copiedTodo.category, originalTodo.category);
      expect(copiedTodo.isCompleted, originalTodo.isCompleted);
      expect(copiedTodo.createdAt, originalTodo.createdAt);
    });

    test('should set completedAt when toggling from incomplete to complete', () {
      final todo = TodoItem(
        id: '6',
        title: 'Completion Time Test',
        description: 'Test completedAt timestamp',
        category: TodoCategory.displayVulnerability,
      );

      final beforeToggle = DateTime.now();
      todo.toggleCompletion();
      final afterToggle = DateTime.now();

      expect(todo.isCompleted, true);
      expect(todo.completedAt, isNotNull);
      expect(todo.completedAt!.isAfter(beforeToggle.subtract(const Duration(seconds: 1))), true);
      expect(todo.completedAt!.isBefore(afterToggle.add(const Duration(seconds: 1))), true);
    });

    test('should handle empty description', () {
      final todo = TodoItem(
        id: '7',
        title: 'No Description Task',
        description: '',
        category: TodoCategory.flexMuscles,
      );

      expect(todo.description, '');
      expect(todo.description.isEmpty, true);
    });
  });
}