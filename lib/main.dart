import 'package:flutter/material.dart';
import 'controllers/settings_controller.dart';
import 'services/db_provider.dart';
import 'views/splash_view.dart';
import 'views/home_view.dart';
import 'views/article_view.dart';
import 'views/browser_view.dart';
import 'views/bookmarks_view.dart';
import 'views/search_view.dart';
import 'views/settings_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBProvider.db.initDB();
  SettingsController.loadTheme();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SettingsController.themeNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = SettingsController.isDarkMode;
    return MaterialApp(
      title: 'Newsly',
      theme: isDark
          ? ThemeData.dark()
          : ThemeData(
        primaryColor: const Color(0xFFFF5252),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF5252),
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/':        (ctx) => const SplashView(),
        '/home':    (ctx) => const HomeView(),
        '/article': (ctx) => const ArticleView(),
        '/browser': (ctx) => const BrowserView(),
        '/bookmarks': (ctx) => const BookmarksView(),
        '/search':  (ctx) => const SearchView(),
        '/settings':(ctx) => const SettingsView(),
      },
    );
  }
}
