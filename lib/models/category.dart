import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final Color color;
  final IconData icon;

  Category({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });

  Category copyWith({String? id, String? name, Color? color, IconData? icon}) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color.toARGB32(),
      'icon': icon.codePoint,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      color: Color(json['color']),
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
    );
  }

  static List<Category> getDefaultCategories() {
    return [
      Category(id: 'work', name: '工作', color: Colors.blue, icon: Icons.work),
      Category(
        id: 'personal',
        name: '个人',
        color: Colors.green,
        icon: Icons.person,
      ),
      Category(
        id: 'study',
        name: '学习',
        color: Colors.orange,
        icon: Icons.school,
      ),
      Category(
        id: 'health',
        name: '健康',
        color: Colors.red,
        icon: Icons.favorite,
      ),
    ];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
