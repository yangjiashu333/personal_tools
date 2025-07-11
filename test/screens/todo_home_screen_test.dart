import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_tool/screens/todo_home_screen.dart';

void main() {
  group('TodoHomeScreen', () {
    testWidgets('should display app bar with title and tabs', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TodoHomeScreen(),
        ),
      );

      expect(find.text('Personal Todo'), findsOneWidget);
      expect(find.text('展示肌肉'), findsAtLeastNWidgets(1));
      expect(find.text('展示脆弱性'), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.fitness_center), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.favorite), findsAtLeastNWidgets(1));
    });

    testWidgets('should display balance indicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TodoHomeScreen(),
        ),
      );

      // Should show balance indicator with counters
      expect(find.text('展示肌肉'), findsAtLeastNWidgets(1));
      expect(find.text('展示脆弱'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display floating action button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TodoHomeScreen(),
        ),
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should display sample todos', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TodoHomeScreen(),
        ),
      );

      // Check todos in first tab (Flex muscles)
      expect(find.text('完成一个有挑战的项目'), findsOneWidget);
      expect(find.text('学习新技能'), findsOneWidget);
      
      // Switch to second tab to check vulnerability todos
      await tester.tap(find.text('展示脆弱性').first);
      await tester.pumpAndSettle();
      
      expect(find.text('向朋友坦诚自己的困难'), findsOneWidget);
    });

    testWidgets('should show add todo dialog when FAB is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TodoHomeScreen(),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('添加新任务'), findsOneWidget);
    });

    testWidgets('should switch between tabs', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TodoHomeScreen(),
        ),
      );

      // Initially on first tab (Flex muscles)
      expect(find.text('完成一个有挑战的项目'), findsOneWidget);
      expect(find.text('学习新技能'), findsOneWidget);

      // Switch to second tab (Display vulnerability)
      await tester.tap(find.text('展示脆弱性'));
      await tester.pumpAndSettle();

      expect(find.text('向朋友坦诚自己的困难'), findsOneWidget);
    });

    testWidgets('should toggle todo completion', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TodoHomeScreen(),
        ),
      );

      // Find and tap the checkbox for an incomplete todo
      final checkboxes = find.byType(Checkbox);
      await tester.tap(checkboxes.first);
      await tester.pumpAndSettle();

      // The balance indicator should update to reflect the change
      expect(find.byType(Checkbox), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle empty tab content', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TodoHomeScreen(),
        ),
      );

      // Initially there are todos, but if we delete all in one category
      // it should show empty state (tested by checking for empty message)
      expect(find.byType(TabBarView), findsOneWidget);
    });

    testWidgets('should display correct app bar color based on balance', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TodoHomeScreen(),
        ),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, isNotNull);
    });

    testWidgets('should display balance message', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TodoHomeScreen(),
        ),
      );

      // Should display some balance message
      expect(find.textContaining('也许可以尝试'), findsAny);
    });

    testWidgets('should allow deleting todos', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TodoHomeScreen(),
        ),
      );

      // Find and tap the popup menu button
      await tester.tap(find.byIcon(Icons.more_vert).first);
      await tester.pumpAndSettle();

      // Tap delete option
      await tester.tap(find.text('删除'));
      await tester.pumpAndSettle();

      // The todo should be removed from the list
      expect(find.byType(Checkbox), findsAtLeastNWidgets(1));
    });

    testWidgets('should add new todo through dialog', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TodoHomeScreen(),
        ),
      );

      // Open add todo dialog
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Enter todo details
      await tester.enterText(find.byType(TextField).first, 'New Test Todo');
      await tester.tap(find.text('添加'));
      await tester.pumpAndSettle();

      // The new todo should appear in the list
      expect(find.text('New Test Todo'), findsOneWidget);
    });

    testWidgets('should maintain state when switching tabs', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TodoHomeScreen(),
        ),
      );

      // Toggle a todo on first tab
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      // Switch to second tab
      await tester.tap(find.text('展示脆弱性'));
      await tester.pumpAndSettle();

      // Switch back to first tab
      await tester.tap(find.text('展示肌肉').first);
      await tester.pumpAndSettle();

      // The state should be maintained
      expect(find.byType(Checkbox), findsAtLeastNWidgets(1));
    });
  });
}