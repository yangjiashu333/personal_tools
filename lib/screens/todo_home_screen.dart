import 'package:flutter/material.dart';
import '../models/todo_item.dart';
import '../models/todo_category.dart';
import '../utils/balance_calculator.dart';
import '../widgets/balance_indicator.dart';
import '../widgets/todo_list_widget.dart';
import '../widgets/add_todo_dialog.dart';

class TodoHomeScreen extends StatefulWidget {
  const TodoHomeScreen({super.key});

  @override
  State<TodoHomeScreen> createState() => _TodoHomeScreenState();
}

class _TodoHomeScreenState extends State<TodoHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<TodoItem> _todos = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeSampleData();
  }

  void _initializeSampleData() {
    _todos = [
      TodoItem(
        id: '1',
        title: '完成一个有挑战的项目',
        description: '展示我的技术能力',
        category: TodoCategory.flexMuscles,
      ),
      TodoItem(
        id: '2',
        title: '向朋友坦诚自己的困难',
        description: '展示脆弱但真实的一面',
        category: TodoCategory.displayVulnerability,
      ),
      TodoItem(
        id: '3',
        title: '学习新技能',
        description: '提升自己的专业能力',
        category: TodoCategory.flexMuscles,
        isCompleted: true,
      ),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleTodo(String id) {
    setState(() {
      final todo = _todos.firstWhere((todo) => todo.id == id);
      todo.toggleCompletion();
    });
  }

  void _addTodo(TodoItem todo) {
    setState(() {
      _todos.add(todo);
    });
  }

  void _deleteTodo(String id) {
    setState(() {
      _todos.removeWhere((todo) => todo.id == id);
    });
  }

  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) => AddTodoDialog(
        onAddTodo: _addTodo,
      ),
    );
  }

  List<TodoItem> _getTodosByCategory(TodoCategory category) {
    return _todos.where((todo) => todo.category == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    final balanceResult = BalanceCalculator.calculateBalance(_todos);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: _getAppBarColor(balanceResult.status),
        title: const Text(
          'Personal Todo',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: const Icon(Icons.fitness_center),
              text: TodoCategory.flexMuscles.displayName,
            ),
            Tab(
              icon: const Icon(Icons.favorite),
              text: TodoCategory.displayVulnerability.displayName,
            ),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
        ),
      ),
      body: Column(
        children: [
          BalanceIndicator(balanceResult: balanceResult),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                TodoListWidget(
                  todos: _getTodosByCategory(TodoCategory.flexMuscles),
                  onToggleTodo: _toggleTodo,
                  onDeleteTodo: _deleteTodo,
                ),
                TodoListWidget(
                  todos: _getTodosByCategory(TodoCategory.displayVulnerability),
                  onToggleTodo: _toggleTodo,
                  onDeleteTodo: _deleteTodo,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        backgroundColor: _getAppBarColor(balanceResult.status),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Color _getAppBarColor(BalanceStatus status) {
    switch (status) {
      case BalanceStatus.balanced:
        return Colors.green;
      case BalanceStatus.warning:
        return Colors.orange;
      case BalanceStatus.empty:
        return Colors.blue;
    }
  }
}