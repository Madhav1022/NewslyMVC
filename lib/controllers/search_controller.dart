import '../models/article.dart';
import '../services/news_service.dart';

class SearchController {
  Future<List<Article>> search(String query) =>
      NewsService.searchArticles(query);
}
