import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'pages/sign_in_page.dart';
import 'models/article.dart';
import 'package:path_provider/path_provider.dart';  // Add this import


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox('your_box_name');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SignInPage(),
    );
  }
}