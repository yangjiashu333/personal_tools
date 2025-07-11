import 'package:flutter/material.dart';
import '../models/todo_item.dart';
import '../models/todo_category.dart';

class TodoListWidget extends StatelessWidget {
  final List<TodoItem> todos;
  final Function(String) onToggleTodo;
  final Function(String) onDeleteTodo;

  const TodoListWidget({
    super.key,
    required this.todos,
    required this.onToggleTodo,
    required this.onDeleteTodo,
  });

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64.0,
              color: Colors.grey,
            ),
            SizedBox(height: 16.0),
            Text(
              '暂无任务',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '点击右下角按钮添加新任务',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return _buildTodoItem(todo);
      },
    );
  }

  Widget _buildTodoItem(TodoItem todo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => onToggleTodo(todo.id),
          activeColor: _getCategoryColor(todo),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            color: todo.isCompleted ? Colors.grey : Colors.black87,
          ),
        ),
        subtitle: todo.description.isNotEmpty
            ? Text(
                todo.description,
                style: TextStyle(
                  fontSize: 14.0,
                  color: todo.isCompleted ? Colors.grey : Colors.grey[600],
                  decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                ),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (todo.isCompleted)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Text(
                  '已完成',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            const SizedBox(width: 8.0),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  onDeleteTodo(todo.id);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8.0),
                      Text('删除'),
                    ],
                  ),
                ),
              ],
              child: const Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(TodoItem todo) {
    switch (todo.category) {
      case TodoCategory.flexMuscles:
        return Colors.blue;
      case TodoCategory.displayVulnerability:
        return Colors.pink;
    }
  }
}