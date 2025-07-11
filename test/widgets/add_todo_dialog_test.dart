import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_tool/models/todo_item.dart';
import 'package:personal_tool/models/todo_category.dart';
import 'package:personal_tool/widgets/add_todo_dialog.dart';

void main() {
  group('AddTodoDialog', () {
    testWidgets('should display dialog with all required fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTodoDialog(
              onAddTodo: (todo) {},
            ),
          ),
        ),
      );

      expect(find.text('添加新任务'), findsOneWidget);
      expect(find.text('任务标题'), findsOneWidget);
      expect(find.text('任务描述'), findsOneWidget);
      expect(find.text('任务类别'), findsOneWidget);
      expect(find.text('取消'), findsOneWidget);
      expect(find.text('添加'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(DropdownButtonFormField<TodoCategory>), findsOneWidget);
    });

    testWidgets('should have flex muscles selected by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTodoDialog(
              onAddTodo: (todo) {},
            ),
          ),
        ),
      );

      // Check that the default text is displayed
      expect(find.text('展示肌肉'), findsOneWidget);
    });

    testWidgets('should allow changing category selection', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTodoDialog(
              onAddTodo: (todo) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DropdownButtonFormField<TodoCategory>));
      await tester.pumpAndSettle();

      expect(find.text('展示肌肉'), findsAtLeastNWidgets(1));
      expect(find.text('展示脆弱性'), findsAtLeastNWidgets(1));

      await tester.tap(find.text('展示脆弱性').last);
      await tester.pumpAndSettle();

      // Check that the vulnerability category is now displayed
      expect(find.text('展示脆弱性'), findsOneWidget);
    });

    testWidgets('should not submit when title is empty', (WidgetTester tester) async {
      TodoItem? addedTodo;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTodoDialog(
              onAddTodo: (todo) {
                addedTodo = todo;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('添加'));
      await tester.pumpAndSettle();

      expect(addedTodo, null);
    });

    testWidgets('should submit with valid title', (WidgetTester tester) async {
      TodoItem? addedTodo;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTodoDialog(
              onAddTodo: (todo) {
                addedTodo = todo;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField).first, 'Test Task');
      await tester.tap(find.text('添加'));
      await tester.pumpAndSettle();

      expect(addedTodo, isNotNull);
      expect(addedTodo?.title, 'Test Task');
      expect(addedTodo?.description, '');
      expect(addedTodo?.category, TodoCategory.flexMuscles);
      expect(addedTodo?.isCompleted, false);
    });

    testWidgets('should submit with title and description', (WidgetTester tester) async {
      TodoItem? addedTodo;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTodoDialog(
              onAddTodo: (todo) {
                addedTodo = todo;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField).first, 'Test Task');
      await tester.enterText(find.byType(TextField).last, 'Test Description');
      await tester.tap(find.text('添加'));
      await tester.pumpAndSettle();

      expect(addedTodo, isNotNull);
      expect(addedTodo?.title, 'Test Task');
      expect(addedTodo?.description, 'Test Description');
    });

    testWidgets('should submit with display vulnerability category', (WidgetTester tester) async {
      TodoItem? addedTodo;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTodoDialog(
              onAddTodo: (todo) {
                addedTodo = todo;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField).first, 'Vulnerability Task');
      
      // Change category to displayVulnerability
      await tester.tap(find.byType(DropdownButtonFormField<TodoCategory>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('展示脆弱性').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('添加'));
      await tester.pumpAndSettle();

      expect(addedTodo, isNotNull);
      expect(addedTodo?.category, TodoCategory.displayVulnerability);
    });

    testWidgets('should close dialog when cancel is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddTodoDialog(
                      onAddTodo: (todo) {},
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('添加新任务'), findsOneWidget);

      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();

      expect(find.text('添加新任务'), findsNothing);
    });

    testWidgets('should trim whitespace from title and description', (WidgetTester tester) async {
      TodoItem? addedTodo;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTodoDialog(
              onAddTodo: (todo) {
                addedTodo = todo;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField).first, '  Test Task  ');
      await tester.enterText(find.byType(TextField).last, '  Test Description  ');
      await tester.tap(find.text('添加'));
      await tester.pumpAndSettle();

      expect(addedTodo, isNotNull);
      expect(addedTodo?.title, 'Test Task');
      expect(addedTodo?.description, 'Test Description');
    });

    testWidgets('should generate unique ID for each todo', (WidgetTester tester) async {
      TodoItem? addedTodo;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTodoDialog(
              onAddTodo: (todo) {
                addedTodo = todo;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField).first, 'Test Task');
      await tester.tap(find.text('添加'));
      await tester.pumpAndSettle();

      expect(addedTodo, isNotNull);
      expect(addedTodo!.id, isNotEmpty);
      expect(addedTodo!.id, isNot(equals('')));
    });

    testWidgets('should display correct icons for categories', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTodoDialog(
              onAddTodo: (todo) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DropdownButtonFormField<TodoCategory>));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.fitness_center), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.favorite), findsAtLeastNWidgets(1));
    });

    testWidgets('should enforce title character limit', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTodoDialog(
              onAddTodo: (todo) {},
            ),
          ),
        ),
      );

      final titleField = tester.widget<TextField>(find.byType(TextField).first);
      expect(titleField.maxLength, 50);
    });

    testWidgets('should enforce description character limit', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTodoDialog(
              onAddTodo: (todo) {},
            ),
          ),
        ),
      );

      final descriptionField = tester.widget<TextField>(find.byType(TextField).last);
      expect(descriptionField.maxLength, 200);
      expect(descriptionField.maxLines, 3);
    });
  });
}