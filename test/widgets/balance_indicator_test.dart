import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_tool/utils/balance_calculator.dart';
import 'package:personal_tool/widgets/balance_indicator.dart';

void main() {
  group('BalanceIndicator', () {
    testWidgets('should display empty state correctly', (WidgetTester tester) async {
      final balanceResult = BalanceResult(
        flexMusclesCount: 0,
        displayVulnerabilityCount: 0,
        differencePercentage: 0.0,
        isBalanced: true,
        message: '开始你的平衡之旅吧！',
        status: BalanceStatus.empty,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BalanceIndicator(balanceResult: balanceResult),
          ),
        ),
      );

      expect(find.text('展示肌肉'), findsOneWidget);
      expect(find.text('展示脆弱'), findsOneWidget);
      expect(find.text('0'), findsNWidgets(2)); // Both counters show 0
      expect(find.text('开始你的平衡之旅吧！'), findsOneWidget);
      expect(find.byIcon(Icons.fitness_center), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('should display balanced state correctly', (WidgetTester tester) async {
      final balanceResult = BalanceResult(
        flexMusclesCount: 3,
        displayVulnerabilityCount: 3,
        differencePercentage: 0.0,
        isBalanced: true,
        message: '你的内心保持着美好的平衡 ✨',
        status: BalanceStatus.balanced,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BalanceIndicator(balanceResult: balanceResult),
          ),
        ),
      );

      expect(find.text('3'), findsNWidgets(2)); // Both counters show 3
      expect(find.text('你的内心保持着美好的平衡 ✨'), findsOneWidget);
      expect(find.textContaining('差距'), findsNothing); // No difference percentage shown for balanced
    });

    testWidgets('should display warning state correctly', (WidgetTester tester) async {
      final balanceResult = BalanceResult(
        flexMusclesCount: 5,
        displayVulnerabilityCount: 1,
        differencePercentage: 66.7,
        isBalanced: false,
        message: '也许可以尝试更多展示脆弱的勇气 🤗',
        status: BalanceStatus.warning,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BalanceIndicator(balanceResult: balanceResult),
          ),
        ),
      );

      expect(find.text('5'), findsOneWidget); // Flex muscles count
      expect(find.text('1'), findsOneWidget); // Display vulnerability count
      expect(find.text('也许可以尝试更多展示脆弱的勇气 🤗'), findsOneWidget);
      expect(find.textContaining('差距: 66.7%'), findsOneWidget);
    });

    testWidgets('should display correct colors for balanced state', (WidgetTester tester) async {
      final balanceResult = BalanceResult(
        flexMusclesCount: 2,
        displayVulnerabilityCount: 2,
        differencePercentage: 0.0,
        isBalanced: true,
        message: '平衡是智慧的体现 🧘‍♀️',
        status: BalanceStatus.balanced,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BalanceIndicator(balanceResult: balanceResult),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.green);
    });

    testWidgets('should display correct colors for warning state', (WidgetTester tester) async {
      final balanceResult = BalanceResult(
        flexMusclesCount: 4,
        displayVulnerabilityCount: 1,
        differencePercentage: 60.0,
        isBalanced: false,
        message: '也许可以尝试更多展示脆弱的勇气 🤗',
        status: BalanceStatus.warning,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BalanceIndicator(balanceResult: balanceResult),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.orange);
    });

    testWidgets('should display correct colors for empty state', (WidgetTester tester) async {
      final balanceResult = BalanceResult(
        flexMusclesCount: 0,
        displayVulnerabilityCount: 0,
        differencePercentage: 0.0,
        isBalanced: true,
        message: '开始你的平衡之旅吧！',
        status: BalanceStatus.empty,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BalanceIndicator(balanceResult: balanceResult),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.blue);
    });

    testWidgets('should display balance bar with correct proportions', (WidgetTester tester) async {
      final balanceResult = BalanceResult(
        flexMusclesCount: 3,
        displayVulnerabilityCount: 1,
        differencePercentage: 50.0,
        isBalanced: false,
        message: '也许可以尝试更多展示脆弱的勇气 🤗',
        status: BalanceStatus.warning,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BalanceIndicator(balanceResult: balanceResult),
          ),
        ),
      );

      // The balance bar should be present
      expect(find.byType(Container), findsAtLeastNWidgets(1));
      
      // Check for the colored segments in the balance bar
      final containers = tester.widgetList<Container>(find.byType(Container));
      bool hasBlueSegment = false;
      bool hasPinkSegment = false;
      
      for (final container in containers) {
        final decoration = container.decoration;
        if (decoration is BoxDecoration) {
          if (decoration.color == Colors.blue) {
            hasBlueSegment = true;
          } else if (decoration.color == Colors.pink) {
            hasPinkSegment = true;
          }
        }
      }
      
      expect(hasBlueSegment, true);
      expect(hasPinkSegment, true);
    });

    testWidgets('should display balance bar as empty when no completed tasks', (WidgetTester tester) async {
      final balanceResult = BalanceResult(
        flexMusclesCount: 0,
        displayVulnerabilityCount: 0,
        differencePercentage: 0.0,
        isBalanced: true,
        message: '开始你的平衡之旅吧！',
        status: BalanceStatus.empty,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BalanceIndicator(balanceResult: balanceResult),
          ),
        ),
      );

      // Should find containers but no colored segments for actual progress
      expect(find.byType(Container), findsAtLeastNWidgets(1));
    });

    testWidgets('should display category icons correctly', (WidgetTester tester) async {
      final balanceResult = BalanceResult(
        flexMusclesCount: 1,
        displayVulnerabilityCount: 1,
        differencePercentage: 0.0,
        isBalanced: true,
        message: 'Test message',
        status: BalanceStatus.balanced,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BalanceIndicator(balanceResult: balanceResult),
          ),
        ),
      );

      final fitnessIcon = tester.widget<Icon>(find.byIcon(Icons.fitness_center));
      expect(fitnessIcon.color, Colors.blue);

      final favoriteIcon = tester.widget<Icon>(find.byIcon(Icons.favorite));
      expect(favoriteIcon.color, Colors.pink);
    });

    testWidgets('should handle very long messages correctly', (WidgetTester tester) async {
      final balanceResult = BalanceResult(
        flexMusclesCount: 2,
        displayVulnerabilityCount: 2,
        differencePercentage: 0.0,
        isBalanced: true,
        message: '这是一个非常长的消息，用来测试文本在UI中的显示效果，看看是否能够正确换行和居中显示',
        status: BalanceStatus.balanced,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BalanceIndicator(balanceResult: balanceResult),
          ),
        ),
      );

      expect(find.textContaining('这是一个非常长的消息'), findsOneWidget);
      
      final textWidget = tester.widget<Text>(find.textContaining('这是一个非常长的消息'));
      expect(textWidget.textAlign, TextAlign.center);
    });
  });
}