import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryArticlesPage extends StatefulWidget {
  final String category;

  const CategoryArticlesPage({super.key, required this.category});

  @override
  State<CategoryArticlesPage> createState() => _CategoryArticlesPageState();
}

class _CategoryArticlesPageState extends State<CategoryArticlesPage> {
  final ApiService _apiService = ApiService();
  late Future<List<Article>> _articlesFuture;
  Set<String> _favoriteArticles = {};
  bool _showingFavorites = false;

  @override
  void initState() {
    super.initState();
    _articlesFuture = _apiService.fetchArticlesByCategory(widget.category);
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteArticles = Set<String>.from(prefs.getStringList('favorites') ?? []);
    });
  }

  Future<void> _toggleFavorite(String articleTitle) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favoriteArticles.contains(articleTitle)) {
        _favoriteArticles.remove(articleTitle);
      } else {
        _favoriteArticles.add(articleTitle);
      }
    });
    await prefs.setStringList('favorites', _favoriteArticles.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_showingFavorites 
          ? 'Favorite Articles' 
          : '${widget.category.substring(0,1).toUpperCase()}${widget.category.substring(1)} News'),
      ),
      body: FutureBuilder<List<Article>>(
        future: _articlesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No articles found'));
          }

          final articles = snapshot.data!;
          final displayedArticles = _showingFavorites 
              ? articles.where((article) => _favoriteArticles.contains(article.title)).toList()
              : articles;

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: displayedArticles.length,
            itemBuilder: (context, index) {
              final article = displayedArticles[index];
              return Card(
                elevation: 4,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: article.urlToImage != null
                              ? Image.network(
                                  article.urlToImage!,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(Icons.image_not_supported),
                                    );
                                  },
                                )
                              : const Center(
                                  child: Icon(Icons.image_not_supported),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            article.title ?? 'No Title',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(
                          _favoriteArticles.contains(article.title)
                              ? Icons.star
                              : Icons.star_border,
                          color: _favoriteArticles.contains(article.title)
                              ? Colors.yellow
                              : Colors.grey,
                        ),
                        onPressed: () => _toggleFavorite(article.title ?? ''),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _showingFavorites ? 1 : 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
        onTap: (index) {
          setState(() {
            _showingFavorites = index == 1;
          });
        },
      ),
    );
  }
} 