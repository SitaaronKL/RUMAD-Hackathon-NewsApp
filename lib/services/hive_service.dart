import 'package:hive/hive.dart';
import '../models/article.dart';

class HiveService {
  static const String _boxName = 'articlesBox';

  Future<void> openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<Article>(_boxName);
    }
  }

  Box<Article> getBox() {
    return Hive.box<Article>(_boxName);
  }

  Future<void> saveArticles(List<Article> articles) async {
    final box = getBox();
    await box.clear();
    await box.addAll(articles);
  }

  List<Article> getSavedArticles() {
    final box = getBox();
    return box.values.toList();
  }
}
