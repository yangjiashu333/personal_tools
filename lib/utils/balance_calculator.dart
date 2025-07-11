import '../models/todo_item.dart';
import '../models/todo_category.dart';

class BalanceResult {
  final int flexMusclesCount;
  final int displayVulnerabilityCount;
  final double differencePercentage;
  final bool isBalanced;
  final String message;
  final BalanceStatus status;

  BalanceResult({
    required this.flexMusclesCount,
    required this.displayVulnerabilityCount,
    required this.differencePercentage,
    required this.isBalanced,
    required this.message,
    required this.status,
  });
}

enum BalanceStatus {
  balanced,
  warning,
  empty,
}

class BalanceCalculator {
  static BalanceResult calculateBalance(List<TodoItem> todos) {
    final completedTodos = todos.where((todo) => todo.isCompleted).toList();
    
    final flexMusclesCount = completedTodos
        .where((todo) => todo.category == TodoCategory.flexMuscles)
        .length;
    
    final displayVulnerabilityCount = completedTodos
        .where((todo) => todo.category == TodoCategory.displayVulnerability)
        .length;
    
    final totalCompleted = flexMusclesCount + displayVulnerabilityCount;
    
    if (totalCompleted == 0) {
      return BalanceResult(
        flexMusclesCount: flexMusclesCount,
        displayVulnerabilityCount: displayVulnerabilityCount,
        differencePercentage: 0.0,
        isBalanced: true,
        message: '开始你的平衡之旅吧！',
        status: BalanceStatus.empty,
      );
    }
    
    final double differencePercentage = 
        ((flexMusclesCount - displayVulnerabilityCount).abs() / totalCompleted) * 100;
    
    final bool isBalanced = differencePercentage <= 30.0;
    
    String message;
    BalanceStatus status;
    
    if (isBalanced) {
      message = _getBalancedMessage(flexMusclesCount, displayVulnerabilityCount);
      status = BalanceStatus.balanced;
    } else {
      message = _getWarningMessage(flexMusclesCount, displayVulnerabilityCount);
      status = BalanceStatus.warning;
    }
    
    return BalanceResult(
      flexMusclesCount: flexMusclesCount,
      displayVulnerabilityCount: displayVulnerabilityCount,
      differencePercentage: differencePercentage,
      isBalanced: isBalanced,
      message: message,
      status: status,
    );
  }
  
  static String _getBalancedMessage(int flexCount, int vulnerabilityCount) {
    final messages = [
      '你的内心保持着美好的平衡 ✨',
      '力量与柔软并存，真正的成长 🌱',
      '在展示与坦诚之间找到了和谐 🎯',
      '平衡是智慧的体现 🧘‍♀️',
      '你正在成为最好的自己 💫',
    ];
    
    return messages[DateTime.now().millisecond % messages.length];
  }
  
  static String _getWarningMessage(int flexCount, int vulnerabilityCount) {
    if (flexCount > vulnerabilityCount) {
      return '也许可以尝试更多展示脆弱的勇气 🤗';
    } else {
      return '也许可以尝试更多展示力量的时刻 💪';
    }
  }
}