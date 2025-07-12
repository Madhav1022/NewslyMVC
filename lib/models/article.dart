import 'dart:convert';

class Article {
  final String id;
  final String title;
  final String author;
  final String source;
  final DateTime publishedAt;
  final String imageUrl;
  final String content;
  final String url;

  Article({
    required this.id,
    required this.title,
    required this.author,
    required this.source,
    required this.publishedAt,
    required this.imageUrl,
    required this.content,
    required this.url,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      source: json['source'],
      publishedAt: DateTime.parse(json['publishedAt']),
      imageUrl: json['imageUrl'],
      content: json['content'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'source': source,
      'publishedAt': publishedAt.toIso8601String(),
      'imageUrl': imageUrl,
      'content': content,
      'url': url,
    };
  }

  factory Article.fromDb(Map<String, dynamic> dbJson) {
    return Article(
      id: dbJson['id'],
      title: dbJson['title'],
      author: dbJson['author'],
      source: dbJson['source'],
      publishedAt: DateTime.parse(dbJson['publishedAt']),
      imageUrl: dbJson['imageUrl'],
      content: dbJson['content'],
      url: dbJson['url'],
    );
  }

  Map<String, dynamic> toDb() => toJson();
}
