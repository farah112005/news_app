// services/news_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/article_model.dart';

class NewsService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://newsapi.org/v2';

  NewsService() {
    _dio.options.headers['Authorization'] = dotenv.env['NEWS_API_KEY'];
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  Future<List<ArticleModel>> fetchTopHeadlines({String country = 'us'}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/top-headlines',
        queryParameters: {'country': country, 'pageSize': 20},
      );

      final articles = (response.data['articles'] as List)
          .map((json) => ArticleModel.fromJson(json))
          .toList();
      return articles;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ArticleModel>> fetchNewsByCategory(
    String category, {
    int page = 1,
  }) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/top-headlines',
        queryParameters: {
          'category': category,
          'country': 'us',
          'pageSize': 20,
          'page': page,
        },
      );

      return (response.data['articles'] as List)
          .map((json) => ArticleModel.fromJson(json, category: category))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ArticleModel>> searchNews(String query) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/everything',
        queryParameters: {'q': query, 'pageSize': 20, 'sortBy': 'publishedAt'},
      );

      return (response.data['articles'] as List)
          .map((json) => ArticleModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getNewsSources() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/sources',
        queryParameters: {'language': 'en', 'country': 'us'},
      );

      return (response.data['sources'] as List)
          .map((source) => source['name'].toString())
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
