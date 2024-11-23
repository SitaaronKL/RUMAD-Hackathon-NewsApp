import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ApiService {
  final String _apiKey =
      'b0d61cdfb4c1465ead26ac9e4bc0f04e'; // Replace with your NewsAPI key

  Future<List<Article>> fetchTopHeadlines() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=$_apiKey'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['articles'];
      return jsonData.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load top headlines');
    }
  }

  Future<List<Article>> searchArticles(String query) async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?q=$query&apiKey=$_apiKey'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['articles'];
      return jsonData.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search articles');
    }
  }

  Future<List<Article>> fetchArticlesByCategory(String category) async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=$_apiKey'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['articles'];
      return jsonData.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load $category articles');
    }
  }
}
