import 'package:flutter/material.dart';
import '../models/todo_item.dart';
import '../models/todo_category.dart';

class AddTodoDialog extends StatefulWidget {
  final Function(TodoItem) onAddTodo;

  const AddTodoDialog({
    super.key,
    required this.onAddTodo,
  });

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TodoCategory _selectedCategory = TodoCategory.flexMuscles;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitTodo() {
    if (_titleController.text.trim().isEmpty) {
      return;
    }

    final todo = TodoItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
    );

    widget.onAddTodo(todo);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('添加新任务'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '任务标题',
                hintText: '输入任务标题',
                border: OutlineInputBorder(),
              ),
              maxLength: 50,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '任务描述',
                hintText: '输入任务描述（可选）',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              maxLength: 200,
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<TodoCategory>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: '任务类别',
                border: OutlineInputBorder(),
              ),
              items: TodoCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Row(
                    children: [
                      Icon(
                        _getCategoryIcon(category),
                        color: _getCategoryColor(category),
                      ),
                      const SizedBox(width: 8.0),
                      Text(category.displayName),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _submitTodo,
          style: ElevatedButton.styleFrom(
            backgroundColor: _getCategoryColor(_selectedCategory),
            foregroundColor: Colors.white,
          ),
          child: const Text('添加'),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(TodoCategory category) {
    switch (category) {
      case TodoCategory.flexMuscles:
        return Icons.fitness_center;
      case TodoCategory.displayVulnerability:
        return Icons.favorite;
    }
  }

  Color _getCategoryColor(TodoCategory category) {
    switch (category) {
      case TodoCategory.flexMuscles:
        return Colors.blue;
      case TodoCategory.displayVulnerability:
        return Colors.pink;
    }
  }
}