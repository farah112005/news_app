// lib/repositories/news_repository.dart
import '../services/news_service.dart';
import '../models/article_model.dart';

class NewsRepository {
  final NewsService newsService;

  NewsRepository(this.newsService);

  Future<List<ArticleModel>> fetchTopHeadlines() async {
    final rawArticles = await newsService.getTopHeadlines();
    return rawArticles.map((json) => ArticleModel.fromJson(json)).toList();
  }
}
