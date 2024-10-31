import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/api_service.dart';
import '../services/hive_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  final HiveService _hiveService = HiveService();
  List<Article> _articles = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeArticles();
  }

  Future<void> _initializeArticles() async {
    await _hiveService.openBox();
    await _loadArticles();
  }

  Future<void> _loadArticles() async {
    try {
      List<Article> articles = await _apiService.fetchTopHeadlines();
      await _hiveService.saveArticles(articles);
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      // Load articles from local storage if API call fails
      setState(() {
        _articles = _hiveService.getSavedArticles();
        _isLoading = false;
      });
    }
  }

  void _searchArticles(String query) async {
    if (query.isEmpty) {
      await _loadArticles();
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      List<Article> articles = await _apiService.searchArticles(query);
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildArticleItem(Article article) {
    return ListTile(
      leading: article.urlToImage != null && article.urlToImage!.isNotEmpty
          ? Image.network(article.urlToImage!, width: 100, fit: BoxFit.cover)
          : null,
      title: Text(article.title ?? 'No Title'),
      subtitle: Text(article.description ?? 'No Description'),
      onTap: () {
        // Handle article tap, e.g., navigate to detail page or open URL
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('News App'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(56.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onSubmitted: _searchArticles,
                decoration: InputDecoration(
                  hintText: 'Search Articles',
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _searchArticles('');
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _articles.isEmpty
                ? Center(child: Text('No articles found.'))
                : ListView.builder(
                    itemCount: _articles.length,
                    itemBuilder: (context, index) {
                      return _buildArticleItem(_articles[index]);
                    },
                  ));
  }
}
