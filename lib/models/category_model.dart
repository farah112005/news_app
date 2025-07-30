import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String displayName;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final int? articleCount;

  CategoryModel({
    required this.id,
    required this.name,
    required this.displayName,
    required this.icon,
    required this.color,
    this.isSelected = false,
    this.articleCount,
  });

  // Factory method to create category from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      displayName: json['displayName'],
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      color: Color(json['color']),
      isSelected: json['isSelected'] ?? false,
      articleCount: json['articleCount'],
    );
  }

  // Method to convert category to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'displayName': displayName,
      'icon': icon.codePoint,
      'color': color.value,
      'isSelected': isSelected,
      'articleCount': articleCount,
    };
  }

  // Create a copy with updated values
  CategoryModel copyWith({
    String? id,
    String? name,
    String? displayName,
    IconData? icon,
    Color? color,
    bool? isSelected,
    int? articleCount,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isSelected: isSelected ?? this.isSelected,
      articleCount: articleCount ?? this.articleCount,
    );
  }

  @override
  String toString() {
    return 'CategoryModel(name: $name, selected: $isSelected)';
  }
}
