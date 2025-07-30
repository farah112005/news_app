import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/services/news_service.dart';

class NewsRepository {
  final NewsService newsService;
  static const String _cacheKey = 'cached_articles';
  static const String _timestampKey = 'cache_timestamp';
  static const Duration _cacheDuration = Duration(minutes: 30);

  NewsRepository({required this.newsService});

  Future<List<ArticleModel>> getTopHeadlines() async {
    final prefs = await SharedPreferences.getInstance();
    final currentTime = DateTime.now();

    // Check cache
    final cachedData = prefs.getString(_cacheKey);
    final timestamp = prefs.getString(_timestampKey);
    if (cachedData != null && timestamp != null) {
      final cacheTime = DateTime.parse(timestamp);
      if (currentTime.difference(cacheTime) < _cacheDuration) {
        final List decoded = jsonDecode(cachedData);
        return decoded.map((e) => ArticleModel.fromJson(e)).toList();
      }
    }

    try {
      final articles = await newsService.fetchTopHeadlines();
      await _saveCache(articles);
      return articles;
    } catch (e) {
      // Fallback to cache on error
      if (cachedData != null) {
        final List decoded = jsonDecode(cachedData);
        return decoded.map((e) => ArticleModel.fromJson(e)).toList();
      }
      rethrow;
    }
  }

  Future<List<ArticleModel>> getNewsByCategory(
    String category, {
    int page = 1,
  }) async {
    try {
      return await newsService.fetchNewsByCategory(category, page: page);
    } catch (e) {
      return [];
    }
  }

  Future<List<ArticleModel>> searchArticles(String query) async {
    return await newsService.searchNews(query);
  }

  Future<void> bookmarkArticle(ArticleModel article) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = prefs.getStringList('bookmarked_articles') ?? [];
    final existing = bookmarks.firstWhere(
      (e) => jsonDecode(e)['id'] == article.id,
      orElse: () => '',
    );

    if (existing.isEmpty) {
      bookmarks.add(jsonEncode(article.toJson()));
      await prefs.setStringList('bookmarked_articles', bookmarks);
    }
  }

  Future<List<ArticleModel>> getBookmarkedArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = prefs.getStringList('bookmarked_articles') ?? [];
    return bookmarks.map((e) => ArticleModel.fromJson(jsonDecode(e))).toList();
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    await prefs.remove(_timestampKey);
  }

  Future<void> _saveCache(List<ArticleModel> articles) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = articles.map((a) => a.toJson()).toList();
    await prefs.setString(_cacheKey, jsonEncode(jsonList));
    await prefs.setString(_timestampKey, DateTime.now().toIso8601String());
  }
}
