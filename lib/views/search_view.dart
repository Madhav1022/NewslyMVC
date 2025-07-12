import 'package:flutter/material.dart';
import '../controllers/search_controller.dart' as app_ctrl;
import '../models/article.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final app_ctrl.SearchController controller =
  app_ctrl.SearchController();
  List<Article> results = [];
  bool loading = false;

  void doSearch(String q) async {
    setState(() => loading = true);
    results = await controller.search(q);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search articles…',
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: doSearch,
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: results.map((a) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 8, horizontal: 16),
            child: Row(
              children: [
                Image.network(
                  a.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
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
                        style:
                        Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        a.source,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                        Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
