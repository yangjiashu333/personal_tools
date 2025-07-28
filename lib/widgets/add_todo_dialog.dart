import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_tool/models/todo.dart';
import 'package:personal_tool/models/category.dart';
import 'package:personal_tool/models/tag.dart';
import 'package:personal_tool/providers/todo_provider.dart';
import 'package:personal_tool/providers/category_provider.dart';
import 'package:personal_tool/providers/tag_provider.dart';

class AddTodoDialog extends ConsumerStatefulWidget {
  final Todo? todoToEdit;

  const AddTodoDialog({super.key, this.todoToEdit});

  @override
  ConsumerState<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends ConsumerState<AddTodoDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagController = TextEditingController();
  
  Category? _selectedCategory;
  final List<Tag> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    if (widget.todoToEdit != null) {
      _titleController.text = widget.todoToEdit!.title;
      _descriptionController.text = widget.todoToEdit!.description;
      _selectedCategory = widget.todoToEdit!.category;
      _selectedTags.addAll(widget.todoToEdit!.tags);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);
    final tags = ref.watch(tagProvider);
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.todoToEdit != null ? '编辑任务' : '添加新任务',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: '任务标题 *',
                          border: OutlineInputBorder(),
                        ),
                        autofocus: true,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: '任务描述',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '选择分类 *',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        children: categories.map((category) {
                          final isSelected = _selectedCategory?.id == category.id;
                          return FilterChip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  category.icon,
                                  size: 16,
                                  color: isSelected ? Colors.white : category.color,
                                ),
                                const SizedBox(width: 4),
                                Text(category.name),
                              ],
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = selected ? category : null;
                              });
                            },
                            selectedColor: category.color,
                            checkmarkColor: Colors.white,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '标签',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _tagController,
                              decoration: const InputDecoration(
                                hintText: '输入新标签名称',
                                border: OutlineInputBorder(),
                              ),
                              onSubmitted: _addNewTag,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => _addNewTag(_tagController.text),
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (tags.isNotEmpty) ...[
                        Text('现有标签：', style: theme.textTheme.bodySmall),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4.0,
                          children: tags.map((tag) {
                            final isSelected = _selectedTags.contains(tag);
                            return FilterChip(
                              label: Text(tag.name),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedTags.add(tag);
                                  } else {
                                    _selectedTags.remove(tag);
                                  }
                                });
                              },
                              selectedColor: tag.color,
                              checkmarkColor: _getContrastColor(tag.color),
                            );
                          }).toList(),
                        ),
                      ],
                      if (_selectedTags.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text('已选标签：', style: theme.textTheme.bodySmall),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4.0,
                          children: _selectedTags.map((tag) {
                            return Chip(
                              label: Text(
                                tag.name,
                                style: TextStyle(
                                  color: _getContrastColor(tag.color),
                                ),
                              ),
                              backgroundColor: tag.color,
                              deleteIcon: Icon(
                                Icons.close,
                                color: _getContrastColor(tag.color),
                                size: 16,
                              ),
                              onDeleted: () {
                                setState(() {
                                  _selectedTags.remove(tag);
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('取消'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _canSave ? _saveTodo : null,
                    child: Text(widget.todoToEdit != null ? '更新' : '保存'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get _canSave =>
      _titleController.text.trim().isNotEmpty && _selectedCategory != null;

  void _addNewTag(String tagName) {
    final trimmedName = tagName.trim();
    if (trimmedName.isEmpty) return;

    final existingTag = ref.read(tagProvider).cast<Tag?>().firstWhere(
      (tag) => tag?.name.toLowerCase() == trimmedName.toLowerCase(),
      orElse: () => null,
    );

    if (existingTag != null) {
      if (!_selectedTags.contains(existingTag)) {
        setState(() {
          _selectedTags.add(existingTag);
        });
      }
    } else {
      final newTag = Tag(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: trimmedName,
        color: Tag.generateRandomColor(),
      );
      ref.read(tagProvider.notifier).addTag(newTag);
      setState(() {
        _selectedTags.add(newTag);
      });
    }

    _tagController.clear();
  }

  void _saveTodo() {
    if (!_canSave) return;

    final todo = Todo(
      id: widget.todoToEdit?.id ?? '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory!,
      tags: List.from(_selectedTags),
      isCompleted: widget.todoToEdit?.isCompleted ?? false,
      createdAt: widget.todoToEdit?.createdAt ?? DateTime.now(),
      sortOrder: widget.todoToEdit?.sortOrder ?? 0,
    );

    if (widget.todoToEdit != null) {
      ref.read(todoProvider.notifier).updateTodo(todo);
    } else {
      ref.read(todoProvider.notifier).addTodo(todo);
    }

    Navigator.of(context).pop();
  }

  Color _getContrastColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}