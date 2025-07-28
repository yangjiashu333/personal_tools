import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal_tool/models/todo.dart';
import 'package:personal_tool/models/category.dart';
import 'package:personal_tool/models/tag.dart';

class StorageService {
  static const String _todosKey = 'todos';
  static const String _categoriesKey = 'categories';
  static const String _tagsKey = 'tags';

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    
    if (!_prefs.containsKey(_categoriesKey)) {
      await saveCategories(Category.getDefaultCategories());
    }
  }

  static Future<List<Todo>> getTodos() async {
    final todosJson = _prefs.getString(_todosKey);
    if (todosJson == null) return [];
    
    final List<dynamic> todosList = json.decode(todosJson);
    return todosList.map((todoJson) => Todo.fromJson(todoJson)).toList();
  }

  static Future<void> saveTodos(List<Todo> todos) async {
    final todosJson = json.encode(todos.map((todo) => todo.toJson()).toList());
    await _prefs.setString(_todosKey, todosJson);
  }

  static Future<List<Category>> getCategories() async {
    final categoriesJson = _prefs.getString(_categoriesKey);
    if (categoriesJson == null) return Category.getDefaultCategories();
    
    final List<dynamic> categoriesList = json.decode(categoriesJson);
    return categoriesList.map((categoryJson) => Category.fromJson(categoryJson)).toList();
  }

  static Future<void> saveCategories(List<Category> categories) async {
    final categoriesJson = json.encode(categories.map((category) => category.toJson()).toList());
    await _prefs.setString(_categoriesKey, categoriesJson);
  }

  static Future<List<Tag>> getTags() async {
    final tagsJson = _prefs.getString(_tagsKey);
    if (tagsJson == null) return [];
    
    final List<dynamic> tagsList = json.decode(tagsJson);
    return tagsList.map((tagJson) => Tag.fromJson(tagJson)).toList();
  }

  static Future<void> saveTags(List<Tag> tags) async {
    final tagsJson = json.encode(tags.map((tag) => tag.toJson()).toList());
    await _prefs.setString(_tagsKey, tagsJson);
  }

  static Future<void> clearAll() async {
    await _prefs.remove(_todosKey);
    await _prefs.remove(_categoriesKey);
    await _prefs.remove(_tagsKey);
  }
}