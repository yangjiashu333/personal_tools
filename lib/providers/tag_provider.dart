import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:personal_tool/models/tag.dart';
import 'package:personal_tool/services/storage_service.dart';

class TagNotifier extends StateNotifier<List<Tag>> {
  TagNotifier() : super([]) {
    _loadTags();
  }

  final _uuid = const Uuid();

  Future<void> _loadTags() async {
    final tags = await StorageService.getTags();
    state = tags;
  }

  Future<void> _saveTags() async {
    await StorageService.saveTags(state);
  }

  Future<void> addTag(Tag tag) async {
    final newTag = tag.copyWith(id: _uuid.v4());
    state = [...state, newTag];
    await _saveTags();
  }

  Future<void> updateTag(Tag updatedTag) async {
    state = state
        .map((tag) => tag.id == updatedTag.id ? updatedTag : tag)
        .toList();
    await _saveTags();
  }

  Future<void> deleteTag(String id) async {
    state = state.where((tag) => tag.id != id).toList();
    await _saveTags();
  }

  Tag? getTagById(String id) {
    try {
      return state.firstWhere((tag) => tag.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addTagByName(String name) async {
    final existingTag = state.cast<Tag?>().firstWhere(
      (tag) => tag?.name.toLowerCase() == name.toLowerCase(),
      orElse: () => null,
    );
    
    if (existingTag == null) {
      final newTag = Tag(
        id: _uuid.v4(),
        name: name,
        color: Tag.generateRandomColor(),
      );
      state = [...state, newTag];
      await _saveTags();
    }
  }
}

final tagProvider = StateNotifierProvider<TagNotifier, List<Tag>>((ref) {
  return TagNotifier();
});