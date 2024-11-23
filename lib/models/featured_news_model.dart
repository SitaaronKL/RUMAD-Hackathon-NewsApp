import 'package:flutter/material.dart';

class FeaturedNewsModel {
  String title;
  String description;
  String imageUrl;
  String source;
  String duration;
  Color boxColor;
  bool viewIsSelected;

  FeaturedNewsModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.source,
    required this.duration,
    required this.boxColor,
    this.viewIsSelected = false,
  });

  static List<FeaturedNewsModel> getFeaturedNews() {
    List<FeaturedNewsModel> featured = [];
    // Add sample featured news
    return featured;
  }
} 