import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/api_service.dart';
import '../services/hive_service.dart';
import 'package:flutter_svg/svg.dart';
import '../models/news_category_model.dart';
import '../models/featured_news_model.dart';
import 'business_articles_page.dart';
import 'tech_articles_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  final HiveService _hiveService = HiveService();
  List<Article> _articles = [];
  final TextEditingController _searchController = TextEditingController();
  List<NewsCategoryModel> categories = [];
  List<FeaturedNewsModel> featuredNews = [];

  @override
  void initState() {
    super.initState();
    _getInitialInfo();
  }

  void _getInitialInfo() {
    categories = NewsCategoryModel.getCategories();
    featuredNews = FeaturedNewsModel.getFeaturedNews();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    try {
      List<Article> articles = await _apiService.fetchTopHeadlines();
      await _hiveService.saveArticles(articles);
      setState(() {
        _articles = articles;
      });
    } catch (e) {
      // Load articles from local storage if API call fails
      setState(() {
        _articles = _hiveService.getSavedArticles();
      });
    }
  }

  void _searchArticles(String query) async {
    if (query.isEmpty) {
      await _loadArticles();
      return;
    }
    try {
      List<Article> articles = await _apiService.searchArticles(query);
      setState(() {
        _articles = articles;
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: [
            _categoriesSection(),
            const SizedBox(height: 40),
            _featuredSection(),
            const SizedBox(height: 40),
            _latestNewsSection(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('News App'),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            onSubmitted: _searchArticles,
            decoration: InputDecoration(
              hintText: 'Search Articles',
              fillColor: Colors.white,
              filled: true,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
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
    );
  }

  Widget _categoriesSection() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return CategoryItem(
            category: categories[index],
            articles: _articles,
          );
        },
      ),
    );
  }

  Widget _featuredSection() {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: featuredNews.length,
        itemBuilder: (context, index) {
          return FeaturedNewsItem(news: featuredNews[index]);
        },
      ),
    );
  }

  Widget _latestNewsSection() {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _articles.length,
        itemBuilder: (context, index) {
          return ArticleItem(article: _articles[index]);
        },
      ),
    );
  }
}

class FeaturedNewsItem extends StatelessWidget {
  final FeaturedNewsModel news;

  const FeaturedNewsItem({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            news.imageUrl,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8),
          Text(
            news.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final NewsCategoryModel category;
  final List<Article> articles;

  const CategoryItem({super.key, required this.category, required this.articles});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Category tapped: ${category.name.toLowerCase()}');
        switch (category.name.toLowerCase()) {
          case 'business':
            print('Navigating to Business page');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BusinessArticlesPage(articles: articles),
              ),
            );
            break;
          case 'technology':
            print('Navigating to Tech page');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TechArticlesPage(articles: articles),
              ),
            );
            break;
          default:
            print('No matching category found');
        }
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              category.iconPath,
              height: 40,
              width: 40,
              placeholderBuilder: (BuildContext context) => Container(
                padding: const EdgeInsets.all(8.0),
                child: const CircularProgressIndicator(),
              ),
            ),
            const SizedBox(height: 8),
            Text(category.name),
          ],
        ),
      ),
    );
  }
}

class ArticleItem extends StatelessWidget {
  final Article article;

  const ArticleItem({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          // Handle article tap, e.g., navigate to detail page or open URL
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            article.urlToImage != null && article.urlToImage!.isNotEmpty
                ? Image.network(
                    article.urlToImage!,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 120,
                    color: Colors.grey,
                    child: const Center(child: Icon(Icons.image)),
                  ),
            const SizedBox(height: 8),
            Text(
              article.title ?? 'No Title',
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              article.description ?? 'No Description',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
