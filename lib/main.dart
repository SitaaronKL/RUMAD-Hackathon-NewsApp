import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart'; // Import this package
import 'dart:io'; // Import this for Directory
import 'models/article.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get the application documents directory
  Directory dir = await getApplicationDocumentsDirectory();

  // Initialize Hive with the directory path
  Hive.init(dir.path);

  // Register the Article adapter
  Hive.registerAdapter(ArticleAdapter());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}
