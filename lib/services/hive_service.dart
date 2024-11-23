import 'package:hive/hive.dart';
import '../models/article.dart';

class HiveService {
  static const String _boxName = 'articlesBox';

  Future<void> openBox() async {
    try {
      if (!Hive.isBoxOpen(_boxName)) {
        await Hive.openBox<Article>(_boxName);
      }
    } catch (e) {
      print('Error opening box: $e');
    }
  }

  Box<Article> getBox() {
    return Hive.box<Article>(_boxName);
  }

  Future<void> saveArticles(List<Article> articles) async {
    try {
      final box = getBox();
      await box.clear();
      await box.addAll(articles);
    } catch (e) {
      print('Error saving articles: $e');
    }
  }

  List<Article> getSavedArticles() {
    try {
      final box = getBox();
      return box.values.toList();
    } catch (e) {
      print('Error retrieving articles: $e');
      return [];
    }
  }
}
