import 'package:flutter/material.dart';
import '../models/article.dart';

class TechArticlesPage extends StatelessWidget {
  final List<Article> articles;

  const TechArticlesPage({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tech Articles'),
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return ListTile(
            title: Text(article.title ?? 'No Title'),
            subtitle: Text(article.description ?? 'No Description'),
            onTap: () {
              // Handle article tap
            },
          );
        },
      ),
    );
  }
} 