import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:personal_tool/main.dart';

void main() {
  testWidgets('Todo app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our todo app loads correctly
    expect(find.text('Personal Todo'), findsOneWidget);
    expect(find.text('展示肌肉'), findsAtLeastNWidgets(1));
    expect(find.text('展示脆弱性'), findsAtLeastNWidgets(1));
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // Tap the '+' icon to add a new todo
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify that the add todo dialog appears
    expect(find.text('添加新任务'), findsOneWidget);
  });
}
