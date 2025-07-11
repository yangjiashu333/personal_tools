import 'package:flutter_test/flutter_test.dart';
import 'package:personal_tool/models/todo_item.dart';
import 'package:personal_tool/models/todo_category.dart';
import 'package:personal_tool/utils/balance_calculator.dart';

void main() {
  group('BalanceCalculator', () {
    test('should return empty status when no todos are completed', () {
      final todos = [
        TodoItem(
          id: '1',
          title: 'Incomplete Task 1',
          description: 'Description 1',
          category: TodoCategory.flexMuscles,
        ),
        TodoItem(
          id: '2',
          title: 'Incomplete Task 2',
          description: 'Description 2',
          category: TodoCategory.displayVulnerability,
        ),
      ];

      final result = BalanceCalculator.calculateBalance(todos);

      expect(result.flexMusclesCount, 0);
      expect(result.displayVulnerabilityCount, 0);
      expect(result.differencePercentage, 0.0);
      expect(result.isBalanced, true);
      expect(result.status, BalanceStatus.empty);
      expect(result.message, '开始你的平衡之旅吧！');
    });

    test('should return balanced status when difference is exactly 30%', () {
      final todos = [
        TodoItem(
          id: '1',
          title: 'Flex Task 1',
          description: 'Description 1',
          category: TodoCategory.flexMuscles,
          isCompleted: true,
        ),
        TodoItem(
          id: '2',
          title: 'Flex Task 2',
          description: 'Description 2',
          category: TodoCategory.flexMuscles,
          isCompleted: true,
        ),
        TodoItem(
          id: '3',
          title: 'Flex Task 3',
          description: 'Description 3',
          category: TodoCategory.flexMuscles,
          isCompleted: true,
        ),
        TodoItem(
          id: '4',
          title: 'Vulnerability Task 1',
          description: 'Description 4',
          category: TodoCategory.displayVulnerability,
          isCompleted: true,
        ),
        TodoItem(
          id: '5',
          title: 'Vulnerability Task 2',
          description: 'Description 5',
          category: TodoCategory.displayVulnerability,
          isCompleted: true,
        ),
        TodoItem(
          id: '6',
          title: 'Vulnerability Task 3',
          description: 'Description 6',
          category: TodoCategory.displayVulnerability,
          isCompleted: true,
        ),
        TodoItem(
          id: '7',
          title: 'Vulnerability Task 4',
          description: 'Description 7',
          category: TodoCategory.displayVulnerability,
          isCompleted: true,
        ),
        TodoItem(
          id: '8',
          title: 'Vulnerability Task 5',
          description: 'Description 8',
          category: TodoCategory.displayVulnerability,
          isCompleted: true,
        ),
        TodoItem(
          id: '9',
          title: 'Vulnerability Task 6',
          description: 'Description 9',
          category: TodoCategory.displayVulnerability,
          isCompleted: true,
        ),
        TodoItem(
          id: '10',
          title: 'Vulnerability Task 7',
          description: 'Description 10',
          category: TodoCategory.displayVulnerability,
          isCompleted: true,
        ),
      ];

      final result = BalanceCalculator.calculateBalance(todos);

      expect(result.flexMusclesCount, 3);
      expect(result.displayVulnerabilityCount, 7);
      expect(result.differencePercentage, 40.0); // (7-3)/10 * 100 = 40%
      expect(result.isBalanced, false);
      expect(result.status, BalanceStatus.warning);
      expect(result.message, '也许可以尝试更多展示力量的时刻 💪');
    });

    test('should return balanced status when tasks are perfectly balanced', () {
      final todos = [
        TodoItem(
          id: '1',
          title: 'Flex Task 1',
          description: 'Description 1',
          category: TodoCategory.flexMuscles,
          isCompleted: true,
        ),
        TodoItem(
          id: '2',
          title: 'Flex Task 2',
          description: 'Description 2',
          category: TodoCategory.flexMuscles,
          isCompleted: true,
        ),
        TodoItem(
          id: '3',
          title: 'Vulnerability Task 1',
          description: 'Description 3',
          category: TodoCategory.displayVulnerability,
          isCompleted: true,
        ),
        TodoItem(
          id: '4',
          title: 'Vulnerability Task 2',
          description: 'Description 4',
          category: TodoCategory.displayVulnerability,
          isCompleted: true,
        ),
      ];

      final result = BalanceCalculator.calculateBalance(todos);

      expect(result.flexMusclesCount, 2);
      expect(result.displayVulnerabilityCount, 2);
      expect(result.differencePercentage, 0.0);
      expect(result.isBalanced, true);
      expect(result.status, BalanceStatus.balanced);
      expect(result.message, isNotEmpty);
    });

    test('should return warning status when flex muscles dominate', () {
      final todos = [
        TodoItem(
          id: '1',
          title: 'Flex Task 1',
          description: 'Description 1',
          category: TodoCategory.flexMuscles,
          isCompleted: true,
        ),
        TodoItem(
          id: '2',
          title: 'Flex Task 2',
          description: 'Description 2',
          category: TodoCategory.flexMuscles,
          isCompleted: true,
        ),
        TodoItem(
          id: '3',
          title: 'Flex Task 3',
          description: 'Description 3',
          category: TodoCategory.flexMuscles,
          isCompleted: true,
        ),
        TodoItem(
          id: '4',
          title: 'Flex Task 4',
          description: 'Description 4',
          category: TodoCategory.flexMuscles,
          isCompleted: true,
        ),
        TodoItem(
          id: '5',
          title: 'Vulnerability Task 1',
          description: 'Description 5',
          category: TodoCategory.displayVulnerability,
          isCompleted: true,
        ),
      ];

      final result = BalanceCalculator.calculateBalance(todos);

      expect(result.flexMusclesCount, 4);
      expect(result.displayVulnerabilityCount, 1);
      expect(result.differencePercentage, 60.0); // (4-1)/5 * 100 = 60%
      expect(result.isBalanced, false);
      expect(result.status, BalanceStatus.warning);
      expect(result.message, '也许可以尝试更多展示脆弱的勇气 🤗');
    });

    test('should return warning status when vulnerability tasks dominate', () {
      final todos = [
        TodoItem(
          id: '1',
          title: 'Flex Task 1',
          description: 'Description 1',
          category: TodoCategory.flexMuscles,
          isCompleted: true,
        ),
        TodoItem(
          id: '2',
          title: 'Vulnerability Task 1',
          description: 'Description 2',
          category: TodoCategory.displayVulnerability,
          isCompleted: true,
        ),
        TodoItem(
          id: '3',
          title: 'Vulnerability Task 2',
          description: 'Description 3',
          category: TodoCategory.displayVulnerability,
          isCompleted: true,
        ),
        TodoItem(
          id: '4',
          title: 'Vulnerability Task 3',
          description: 'Description 4',
          category: TodoCategory.displayVulnerability,
          isCompleted: true,
        ),
        TodoItem(
          id: '5',
          title: 'Vulnerability Task 4',
          description: 'Description 5',
          category: TodoCategory.displayVulnerability,
          isCompleted: true,
        ),
      ];

      final result = BalanceCalculator.calculateBalance(todos);

      expect(result.flexMusclesCount, 1);
      expect(result.displayVulnerabilityCount, 4);
      expect(result.differencePercentage, 60.0); // (4-1)/5 * 100 = 60%
      expect(result.isBalanced, false);
      expect(result.status, BalanceStatus.warning);
      expect(result.message, '也许可以尝试更多展示力量的时刻 💪');
    });

    test('should only consider completed todos in calculation', () {
      final todos = [
        TodoItem(
          id: '1',
          title: 'Flex Task 1',
          description: 'Description 1',
          category: TodoCategory.flexMuscles,
          isCompleted: true,
        ),
        TodoItem(
          id: '2',
          title: 'Flex Task 2',
          description: 'Description 2',
          category: TodoCategory.flexMuscles,
          isCompleted: false, // not completed
        ),
        TodoItem(
          id: '3',
          title: 'Vulnerability Task 1',
          description: 'Description 3',
          category: TodoCategory.displayVulnerability,
          isCompleted: true,
        ),
        TodoItem(
          id: '4',
          title: 'Vulnerability Task 2',
          description: 'Description 4',
          category: TodoCategory.displayVulnerability,
          isCompleted: false, // not completed
        ),
      ];

      final result = BalanceCalculator.calculateBalance(todos);

      expect(result.flexMusclesCount, 1);
      expect(result.displayVulnerabilityCount, 1);
      expect(result.differencePercentage, 0.0);
      expect(result.isBalanced, true);
      expect(result.status, BalanceStatus.balanced);
    });

    test('should handle single completed todo', () {
      final todos = [
        TodoItem(
          id: '1',
          title: 'Single Task',
          description: 'Only completed task',
          category: TodoCategory.flexMuscles,
          isCompleted: true,
        ),
      ];

      final result = BalanceCalculator.calculateBalance(todos);

      expect(result.flexMusclesCount, 1);
      expect(result.displayVulnerabilityCount, 0);
      expect(result.differencePercentage, 100.0);
      expect(result.isBalanced, false);
      expect(result.status, BalanceStatus.warning);
    });

    test('should handle edge case with 29% difference (balanced)', () {
      final todos = [
        TodoItem(
          id: '1',
          title: 'Flex Task 1',
          description: 'Description 1',
          category: TodoCategory.flexMuscles,
          isCompleted: true,
        ),
        TodoItem(
          id: '2',
          title: 'Flex Task 2',
          description: 'Description 2',
          category: TodoCategory.flexMuscles,
          isCompleted: true,
        ),
        TodoItem(
          id: '3',
          title: 'Vulnerability Task 1',
          description: 'Description 3',
          category: TodoCategory.displayVulnerability,
          isCompleted: true,
        ),
        TodoItem(
          id: '4',
          title: 'Vulnerability Task 2',
          description: 'Description 4',
          category: TodoCategory.displayVulnerability,
          isCompleted: true,
        ),
        TodoItem(
          id: '5',
          title: 'Vulnerability Task 3',
          description: 'Description 5',
          category: TodoCategory.displayVulnerability,
          isCompleted: true,
        ),
        TodoItem(
          id: '6',
          title: 'Vulnerability Task 4',
          description: 'Description 6',
          category: TodoCategory.displayVulnerability,
          isCompleted: true,
        ),
        TodoItem(
          id: '7',
          title: 'Vulnerability Task 5',
          description: 'Description 7',
          category: TodoCategory.displayVulnerability,
          isCompleted: true,
        ),
      ];

      final result = BalanceCalculator.calculateBalance(todos);

      expect(result.flexMusclesCount, 2);
      expect(result.displayVulnerabilityCount, 5);
      expect(result.differencePercentage, closeTo(42.86, 0.01)); // (5-2)/7 * 100 = 42.86%
      expect(result.isBalanced, false);
      expect(result.status, BalanceStatus.warning);
    });
  });
}