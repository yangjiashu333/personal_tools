import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_tool/models/todo.dart';
import 'package:personal_tool/providers/todo_provider.dart';

class TodoCard extends ConsumerWidget {
  final Todo todo;
  final VoidCallback? onEdit;

  const TodoCard({
    super.key,
    required this.todo,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        elevation: todo.isCompleted ? 1 : 2,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: todo.isCompleted ? 0.7 : 1.0,
          child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (value) {
            ref.read(todoProvider.notifier).toggleTodo(todo.id);
          },
          activeColor: todo.category.color,
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted 
                ? TextDecoration.lineThrough 
                : TextDecoration.none,
            color: todo.isCompleted 
                ? theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6)
                : theme.textTheme.bodyMedium?.color,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (todo.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                todo.description,
                style: TextStyle(
                  decoration: todo.isCompleted 
                      ? TextDecoration.lineThrough 
                      : TextDecoration.none,
                  color: todo.isCompleted 
                      ? theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6)
                      : theme.textTheme.bodySmall?.color,
                ),
              ),
            ],
            if (todo.tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 4.0,
                children: todo.tags.map((tag) => Chip(
                  label: Text(
                    tag.name,
                    style: TextStyle(
                      color: _getContrastColor(tag.color),
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: tag.color,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                )).toList(),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: todo.category.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.drag_handle,
              color: Colors.grey,
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    onEdit?.call();
                    break;
                  case 'delete':
                    _showDeleteDialog(context, ref);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('编辑'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('删除'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getContrastColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除任务 "${todo.title}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              ref.read(todoProvider.notifier).deleteTodo(todo.id);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}