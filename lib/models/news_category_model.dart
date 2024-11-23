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
        name: 'Entertainment',
        iconPath: 'assets/icons/entertainment.svg',
      ),
      NewsCategoryModel(
        name: 'General',
        iconPath: 'assets/icons/general.svg',
      ),
      NewsCategoryModel(
        name: 'Health',
        iconPath: 'assets/icons/health.svg',
      ),
      NewsCategoryModel(
        name: 'Science',
        iconPath: 'assets/icons/science.svg',
      ),
      NewsCategoryModel(
        name: 'Sports',
        iconPath: 'assets/icons/sports.svg',
      ),
      NewsCategoryModel(
        name: 'Technology',
        iconPath: 'assets/icons/technology.svg',
      ),
    ];
  }
} 