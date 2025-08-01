// lib/services/news_service.dart
import 'package:dio/dio.dart';

class NewsService {
  final Dio _dio = Dio();
  final String _apiKey =
      '01f8f9b761694d1ebff53b6f04dc2328'; // استبدليه بمفتاحك من NewsAPI.org
  final String _baseUrl = 'https://newsapi.org/v2';

  Future<List<dynamic>> getTopHeadlines({String country = 'us'}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/top-headlines',
        queryParameters: {'country': country, 'apiKey': _apiKey},
      );
      return response.data['articles'];
    } catch (e) {
      throw Exception('Failed to load news');
    }
  }
}
