// lib/views/article_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/article_model.dart';

class ArticleDetailScreen extends StatelessWidget {
  final ArticleModel article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.source)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl != null)
              Hero(tag: article.url, child: Image.network(article.imageUrl!)),
            const SizedBox(height: 16),
            Text(article.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Published at: ${article.publishedAt.toLocal()}'),
            const SizedBox(height: 16),
            Text(article.description),
            const SizedBox(height: 16),
            Text(article.url, style: const TextStyle(color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}
