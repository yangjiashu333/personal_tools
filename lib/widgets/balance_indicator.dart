import 'package:flutter/material.dart';
import '../utils/balance_calculator.dart';

class BalanceIndicator extends StatelessWidget {
  final BalanceResult balanceResult;

  const BalanceIndicator({
    super.key,
    required this.balanceResult,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: _getBackgroundColor().withValues(alpha: 0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCategoryCounter(
                '展示肌肉',
                balanceResult.flexMusclesCount,
                Icons.fitness_center,
                Colors.blue,
              ),
              _buildCategoryCounter(
                '展示脆弱',
                balanceResult.displayVulnerabilityCount,
                Icons.favorite,
                Colors.pink,
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          _buildBalanceBar(),
          const SizedBox(height: 12.0),
          Text(
            balanceResult.message,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          if (balanceResult.status == BalanceStatus.warning) ...[
            const SizedBox(height: 8.0),
            Text(
              '差距: ${balanceResult.differencePercentage.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.white70,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryCounter(String label, int count, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          size: 28.0,
          color: color,
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceBar() {
    final total = balanceResult.flexMusclesCount + balanceResult.displayVulnerabilityCount;
    if (total == 0) {
      return Container(
        height: 8.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(4.0),
        ),
      );
    }

    final flexRatio = balanceResult.flexMusclesCount / total;
    
    return Container(
      height: 8.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.white.withValues(alpha: 0.3),
      ),
      child: Row(
        children: [
          if (flexRatio > 0)
            Expanded(
              flex: balanceResult.flexMusclesCount,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          if (balanceResult.displayVulnerabilityCount > 0)
            Expanded(
              flex: balanceResult.displayVulnerabilityCount,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (balanceResult.status) {
      case BalanceStatus.balanced:
        return Colors.green;
      case BalanceStatus.warning:
        return Colors.orange;
      case BalanceStatus.empty:
        return Colors.blue;
    }
  }
}