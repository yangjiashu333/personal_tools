import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_tool/models/todo_item.dart';
import 'package:personal_tool/models/todo_category.dart';
import 'package:personal_tool/widgets/todo_list_widget.dart';

void main() {
  group('TodoListWidget', () {
    late List<TodoItem> testTodos;

    setUp(() {
      testTodos = [
        TodoItem(
          id: '1',
          title: 'Test Task 1',
          description: 'Description 1',
          category: TodoCategory.flexMuscles,
          isCompleted: false,
        ),
        TodoItem(
          id: '2',
          title: 'Test Task 2',
          description: 'Description 2',
          category: TodoCategory.displayVulnerability,
          isCompleted: true,
        ),
        TodoItem(
          id: '3',
          title: 'Test Task 3',
          description: '',
          category: TodoCategory.flexMuscles,
          isCompleted: false,
        ),
      ];
    });

    testWidgets('should display empty state when no todos', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoListWidget(
              todos: [],
              onToggleTodo: (id) {},
              onDeleteTodo: (id) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
      expect(find.text('暂无任务'), findsOneWidget);
      expect(find.text('点击右下角按钮添加新任务'), findsOneWidget);
    });

    testWidgets('should display todo items', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoListWidget(
              todos: testTodos,
              onToggleTodo: (id) {},
              onDeleteTodo: (id) {},
            ),
          ),
        ),
      );

      expect(find.text('Test Task 1'), findsOneWidget);
      expect(find.text('Test Task 2'), findsOneWidget);
      expect(find.text('Test Task 3'), findsOneWidget);
      expect(find.text('Description 1'), findsOneWidget);
      expect(find.text('Description 2'), findsOneWidget);
      expect(find.byType(Checkbox), findsNWidgets(3));
    });

    testWidgets('should display completed status for completed todos', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoListWidget(
              todos: testTodos,
              onToggleTodo: (id) {},
              onDeleteTodo: (id) {},
            ),
          ),
        ),
      );

      expect(find.text('已完成'), findsOneWidget);
    });

    testWidgets('should call onToggleTodo when checkbox is tapped', (WidgetTester tester) async {
      String toggledId = '';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoListWidget(
              todos: testTodos,
              onToggleTodo: (id) {
                toggledId = id;
              },
              onDeleteTodo: (id) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Checkbox).first);
      await tester.pump();

      expect(toggledId, '1');
    });

    testWidgets('should call onDeleteTodo when delete menu item is tapped', (WidgetTester tester) async {
      String deletedId = '';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoListWidget(
              todos: testTodos,
              onToggleTodo: (id) {},
              onDeleteTodo: (id) {
                deletedId = id;
              },
            ),
          ),
        ),
      );

      // Find the more_vert icon and tap it
      await tester.tap(find.byIcon(Icons.more_vert).first);
      await tester.pumpAndSettle();

      // Find and tap the delete option
      await tester.tap(find.text('删除'));
      await tester.pump();

      expect(deletedId, '1');
    });

    testWidgets('should display correct checkbox states', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoListWidget(
              todos: testTodos,
              onToggleTodo: (id) {},
              onDeleteTodo: (id) {},
            ),
          ),
        ),
      );

      final checkboxes = tester.widgetList<Checkbox>(find.byType(Checkbox)).toList();
      
      expect(checkboxes[0].value, false); // Task 1 is not completed
      expect(checkboxes[1].value, true);  // Task 2 is completed
      expect(checkboxes[2].value, false); // Task 3 is not completed
    });

    testWidgets('should not display subtitle when description is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoListWidget(
              todos: [testTodos[2]], // Task 3 has empty description
              onToggleTodo: (id) {},
              onDeleteTodo: (id) {},
            ),
          ),
        ),
      );

      expect(find.text('Test Task 3'), findsOneWidget);
      expect(find.text(''), findsNothing);
    });

    testWidgets('should show popup menu when more_vert icon is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoListWidget(
              todos: [testTodos[0]],
              onToggleTodo: (id) {},
              onDeleteTodo: (id) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      expect(find.text('删除'), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('should apply correct styling to completed todos', (WidgetTester tester) async {
      final completedTodo = TodoItem(
        id: '4',
        title: 'Completed Task',
        description: 'Completed Description',
        category: TodoCategory.flexMuscles,
        isCompleted: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoListWidget(
              todos: [completedTodo],
              onToggleTodo: (id) {},
              onDeleteTodo: (id) {},
            ),
          ),
        ),
      );

      final titleWidget = tester.widget<Text>(find.text('Completed Task'));
      expect(titleWidget.style?.decoration, TextDecoration.lineThrough);
      
      final descriptionWidget = tester.widget<Text>(find.text('Completed Description'));
      expect(descriptionWidget.style?.decoration, TextDecoration.lineThrough);
    });

    testWidgets('should display correct category colors for flex muscles', (WidgetTester tester) async {
      final flexTodo = TodoItem(
        id: '5',
        title: 'Flex Task',
        description: 'Flex Description',
        category: TodoCategory.flexMuscles,
        isCompleted: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoListWidget(
              todos: [flexTodo],
              onToggleTodo: (id) {},
              onDeleteTodo: (id) {},
            ),
          ),
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.activeColor, Colors.blue);
    });

    testWidgets('should display correct category colors for display vulnerability', (WidgetTester tester) async {
      final vulnerabilityTodo = TodoItem(
        id: '6',
        title: 'Vulnerability Task',
        description: 'Vulnerability Description',
        category: TodoCategory.displayVulnerability,
        isCompleted: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoListWidget(
              todos: [vulnerabilityTodo],
              onToggleTodo: (id) {},
              onDeleteTodo: (id) {},
            ),
          ),
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.activeColor, Colors.pink);
    });
  });
}