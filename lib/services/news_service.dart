import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class NewsService {
  static const _apiKey = 'ENTER_YOUR_API_KEY_HERE';
  static const _baseUrl = 'https://newsapi.org/v2';

  static Future<List<Article>> fetchTopHeadlines() async {
    final uri = Uri.parse('$_baseUrl/top-headlines?country=us&apiKey=$_apiKey');
    final resp = await http.get(uri);
    if (resp.statusCode != 200) throw Exception('Failed to load headlines');

    final jsonBody = json.decode(resp.body);
    final List articlesJson = jsonBody['articles'];
    return articlesJson.map((js) => Article.fromJson({
      'id': js['url'],                // or generate your own ID
      'title': js['title'] ?? '',
      'author': js['author'] ?? 'Unknown',
      'source': js['source']['name'] ?? '',
      'publishedAt': js['publishedAt'] ?? DateTime.now().toIso8601String(),
      'imageUrl': js['urlToImage'] ?? '',
      'content': js['content'] ?? '',
      'url': js['url'] ?? '',
    })).toList();
  }

  static Future<List<Article>> searchArticles(String query) async {
    final uri = Uri.parse('$_baseUrl/everything?q=$query&apiKey=$_apiKey');
    final resp = await http.get(uri);
    if (resp.statusCode != 200) throw Exception('Search failed');

    final jsonBody = json.decode(resp.body);
    final List articlesJson = jsonBody['articles'];
    return articlesJson.map((js) => Article.fromJson({
      'id': js['url'],
      'title': js['title'] ?? '',
      'author': js['author'] ?? 'Unknown',
      'source': js['source']['name'] ?? '',
      'publishedAt': js['publishedAt'] ?? DateTime.now().toIso8601String(),
      'imageUrl': js['urlToImage'] ?? '',
      'content': js['content'] ?? '',
      'url': js['url'] ?? '',
    })).toList();
  }
}
