import '../models/article.dart';
import '../services/db_provider.dart';

class BookmarksController {
  List<Article> bookmarks = [];

  Future<void> loadBookmarks() async {
    bookmarks = await DBProvider.db.getBookmarks();
  }

  Future<void> toggleBookmark(Article article) async {
    final exists = bookmarks.any((a) => a.id == article.id);
    if (exists) {
      await DBProvider.db.deleteBookmark(article.id);
    } else {
      await DBProvider.db.insertBookmark(article);
    }
    await loadBookmarks();
  }

  bool isBookmarked(String id) {
    return bookmarks.any((a) => a.id == id);
  }
}
