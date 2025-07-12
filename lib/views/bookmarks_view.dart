import 'package:flutter/material.dart';
import '../controllers/bookmarks_controller.dart';
import '../models/article.dart';

class BookmarksView extends StatefulWidget {
  const BookmarksView({Key? key}) : super(key: key);

  @override
  _BookmarksViewState createState() => _BookmarksViewState();
}

class _BookmarksViewState extends State<BookmarksView> {
  final BookmarksController _bmCtrl = BookmarksController();
  List<Article> _bookmarks = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    await _bmCtrl.loadBookmarks();
    setState(() {
      _bookmarks = _bmCtrl.bookmarks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: _bookmarks.isEmpty
          ? const Center(child: Text('No bookmarks yet'))
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _bookmarks.length,
        itemBuilder: (ctx, i) {
          final a = _bookmarks[i];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/article',
                  arguments: a,
                );
              },
              child: Row(
                children: [
                  if (a.imageUrl.startsWith(RegExp(r'https?://')))
                    Image.network(
                      a.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade300,
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          a.source,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await _bmCtrl.toggleBookmark(a);
                      _loadBookmarks();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
