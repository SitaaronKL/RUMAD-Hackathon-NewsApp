import 'package:flutter/material.dart';

class NewsCategoryModel {
  final String name;
  final String iconPath;

  NewsCategoryModel({required this.name, required this.iconPath});

  static List<NewsCategoryModel> getCategories() {
    return [
      NewsCategoryModel(
        name: 'Business',
        iconPath: 'assets/icons/business.svg',
      ),
      NewsCategoryModel(
        name: 'Tech',
        iconPath: 'assets/icons/tech.svg',
      ),
      // Add other categories...
    ];
  }
} 