import '../models/article.dart';
import '../services/news_service.dart';

class HomeController {
  Future<List<Article>> getHeadlines() => NewsService.fetchTopHeadlines();
}
