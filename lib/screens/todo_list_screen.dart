import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../providers/todo_provider.dart';
import '../providers/category_provider.dart';
import '../widgets/statistics_card.dart';
import '../widgets/todo_card.dart';
import '../widgets/add_todo_dialog.dart';

class TodoListScreen extends ConsumerStatefulWidget {
  const TodoListScreen({super.key});

  @override
  ConsumerState<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends ConsumerState<TodoListScreen> {
  final Map<String, bool> _categoryExpanded = {};

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todoProvider);
    final categories = ref.watch(categoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TodoList'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: 实现设置页面
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const StatisticsCard(),
          Expanded(
            child: todos.isEmpty
                ? _buildEmptyState()
                : _buildCategorizedTodoList(categories, todos),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        heroTag: "add_todo",
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('还没有任务', style: TextStyle(fontSize: 18, color: Colors.grey)),
          SizedBox(height: 8),
          Text('点击右下角的 + 按钮添加第一个任务', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildCategorizedTodoList(List<Category> categories, List todos) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final categoryTodos = ref
            .read(todoProvider.notifier)
            .getTodosByCategory(category);

        if (categoryTodos.isEmpty) {
          return const SizedBox.shrink();
        }

        final isExpanded = _categoryExpanded[category.id] ?? true;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: category.color.withValues(alpha: 0.1),
                  child: Icon(category.icon, color: category.color),
                ),
                title: Text(
                  category.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${categoryTodos.length} 个任务'),
                trailing: IconButton(
                  icon: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  onPressed: () {
                    setState(() {
                      _categoryExpanded[category.id] = !isExpanded;
                    });
                  },
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: isExpanded
                    ? Column(
                        children: [
                          const Divider(height: 1),
                          ReorderableListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: categoryTodos.length,
                            onReorder: (oldIndex, newIndex) {
                              _reorderTodosInCategory(
                                category,
                                oldIndex,
                                newIndex,
                              );
                            },
                            itemBuilder: (context, index) {
                              final todo = categoryTodos[index];
                              return Container(
                                key: ValueKey(todo.id),
                                child: TodoCard(
                                  todo: todo,
                                  onEdit: () =>
                                      _showEditTodoDialog(context, todo),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) => const AddTodoDialog(),
      transitionBuilder: (context, animation1, animation2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation1, curve: Curves.easeOut)),
          child: child,
        );
      },
    );
  }

  void _showEditTodoDialog(BuildContext context, todo) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) =>
          AddTodoDialog(todoToEdit: todo),
      transitionBuilder: (context, animation1, animation2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation1, curve: Curves.easeOut)),
          child: child,
        );
      },
    );
  }

  void _reorderTodosInCategory(Category category, int oldIndex, int newIndex) {
    final categoryTodos = ref
        .read(todoProvider.notifier)
        .getTodosByCategory(category);

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final reorderedTodos = List.from(categoryTodos);
    final item = reorderedTodos.removeAt(oldIndex);
    reorderedTodos.insert(newIndex, item);

    // 更新排序顺序
    for (int i = 0; i < reorderedTodos.length; i++) {
      final updatedTodo = reorderedTodos[i].copyWith(sortOrder: i);
      ref.read(todoProvider.notifier).updateTodo(updatedTodo);
    }
  }
}
