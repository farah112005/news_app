// lib/views/search_screen.dart
import 'package:flutter/material.dart';
import '../services/news_service.dart';
import '../models/article_model.dart';
import '../widgets/article_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _newsService = NewsService();
  List<ArticleModel> _results = [];
  bool _loading = false;

  void _search(String query) async {
    setState(() => _loading = true);
    final raw = await _newsService
        .getTopHeadlines(); // استبدليه بـ search API لو متاح
    final articles = raw.map((e) => ArticleModel.fromJson(e)).toList();
    setState(() {
      _results = articles
          .where((a) => a.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search News')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Search...',
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: _search,
            ),
          ),
          if (_loading) const CircularProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (_, i) => ArticleCard(article: _results[i]),
            ),
          ),
        ],
      ),
    );
  }
}
