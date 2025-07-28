import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:personal_tool/models/category.dart';
import 'package:personal_tool/services/storage_service.dart';

class CategoryNotifier extends StateNotifier<List<Category>> {
  CategoryNotifier() : super([]) {
    _loadCategories();
  }

  final _uuid = const Uuid();

  Future<void> _loadCategories() async {
    final categories = await StorageService.getCategories();
    state = categories;
  }

  Future<void> _saveCategories() async {
    await StorageService.saveCategories(state);
  }

  Future<void> addCategory(Category category) async {
    final newCategory = category.copyWith(id: _uuid.v4());
    state = [...state, newCategory];
    await _saveCategories();
  }

  Future<void> updateCategory(Category updatedCategory) async {
    state = state
        .map((category) =>
            category.id == updatedCategory.id ? updatedCategory : category)
        .toList();
    await _saveCategories();
  }

  Future<void> deleteCategory(String id) async {
    state = state.where((category) => category.id != id).toList();
    await _saveCategories();
  }

  Category? getCategoryById(String id) {
    try {
      return state.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }
}

final categoryProvider = StateNotifierProvider<CategoryNotifier, List<Category>>((ref) {
  return CategoryNotifier();
});