import 'package:flutter/material.dart';
import '../models/article.dart';
import '../controllers/bookmarks_controller.dart';

class ArticleView extends StatefulWidget {
  const ArticleView({Key? key}) : super(key: key);

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  late Article _article;
  final BookmarksController _bmCtrl = BookmarksController();
  bool _bookmarked = false;
  bool _isInit = false;      // to ensure we only load once

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _isInit = true;

      // 1. Grab the Article passed from previous screen.
      _article = ModalRoute.of(context)!.settings.arguments as Article;

      // 2. Asynchronously load current bookmarks from DB,
      //    then update the icon state.
      _bmCtrl.loadBookmarks().then((_) {
        final isFav = _bmCtrl.isBookmarked(_article.id);
        setState(() {
          _bookmarked = isFav;
        });
      });
    }
  }

  Future<void> _toggleBookmark() async {
    // Flip in DB:
    await _bmCtrl.toggleBookmark(_article);
    // Flip local state immediately:
    setState(() {
      _bookmarked = !_bookmarked;
    });
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inHours > 1) return '${diff.inHours}h ago';
    if (diff.inMinutes > 1) return '${diff.inMinutes}m ago';
    return 'just now';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_article.source),
        actions: [
          IconButton(
            icon: Icon(
              _bookmarked ? Icons.bookmark : Icons.bookmark_border,
            ),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_article.imageUrl.startsWith(RegExp(r'https?://')))
              Image.network(
                _article.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _article.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'By ${_article.author} · ${_timeAgo(_article.publishedAt)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Text(_article.content),
                  const SizedBox(height: 16),
                  if (_article.url.startsWith('http'))
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/browser',
                        arguments: _article.url,
                      ),
                      child: const Text('Read More'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
