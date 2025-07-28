import 'dart:ui';
import 'dart:math';

class Tag {
  final String id;
  final String name;
  final Color color;

  Tag({required this.id, required this.name, required this.color});

  Tag copyWith({String? id, String? name, Color? color}) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'color': color.toARGB32()};
  }

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(id: json['id'], name: json['name'], color: Color(json['color']));
  }

  static Color generateRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Tag && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
