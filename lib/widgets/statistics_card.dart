import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/statistics_provider.dart';

class StatisticsCard extends ConsumerWidget {
  const StatisticsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statistics = ref.watch(statisticsProvider);
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '任务概览',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatisticItem(
                    label: '总任务',
                    value: statistics.totalTodos.toString(),
                    color: theme.colorScheme.primary,
                    icon: Icons.assignment,
                  ),
                ),
                Expanded(
                  child: _StatisticItem(
                    label: '已完成',
                    value: statistics.completedTodos.toString(),
                    color: Colors.green,
                    icon: Icons.check_circle,
                  ),
                ),
                Expanded(
                  child: _StatisticItem(
                    label: '待完成',
                    value: statistics.incompleteTodos.toString(),
                    color: Colors.orange,
                    icon: Icons.pending,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (statistics.totalTodos > 0) ...[
              Text(
                '完成率',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: statistics.completionRate,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  statistics.completionRate > 0.7
                      ? Colors.green
                      : Colors.orange,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${(statistics.completionRate * 100).toStringAsFixed(1)}%',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatisticItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatisticItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
