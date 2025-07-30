// cubits/news_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/article_model.dart';
import '../repositories/news_repository.dart';
import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsRepository repository;

  int _currentPage = 1;
  bool _hasMore = true;
  List<ArticleModel> _articles = [];

  NewsCubit(this.repository) : super(NewsInitial());

  Future<void> fetchTopHeadlines() async {
    emit(NewsLoading());
    try {
      final articles = await repository.getTopHeadlines();
      _articles = articles;
      _hasMore = articles.length >= 20;
      emit(NewsLoaded(articles: _articles, hasMore: _hasMore));
    } catch (e) {
      emit(NewsError(message: 'Failed to fetch news', canRetry: true));
    }
  }

  Future<void> fetchByCategory(String category) async {
    emit(NewsLoading());
    try {
      _currentPage = 1;
      final articles = await repository.getNewsByCategory(
        category,
        page: _currentPage,
      );
      _articles = articles;
      _hasMore = articles.length >= 20;
      emit(NewsLoaded(articles: _articles, hasMore: _hasMore));
    } catch (e) {
      emit(NewsError(message: 'Failed to load category news', canRetry: true));
    }
  }

  Future<void> searchArticles(String query) async {
    emit(NewsLoading());
    try {
      final articles = await repository.searchArticles(query);
      if (articles.isEmpty) {
        emit(NewsEmpty(message: 'No articles found.'));
      } else {
        emit(NewsLoaded(articles: articles, hasMore: false));
      }
    } catch (e) {
      emit(NewsError(message: 'Search failed', canRetry: true));
    }
  }

  Future<void> refreshNews() async {
    emit(NewsRefreshing());
    await fetchTopHeadlines();
  }

  Future<void> loadMoreArticles(String category) async {
    if (!_hasMore) return;
    try {
      _currentPage++;
      final more = await repository.getNewsByCategory(
        category,
        page: _currentPage,
      );
      if (more.isEmpty) {
        _hasMore = false;
      } else {
        _articles.addAll(more);
        emit(NewsLoaded(articles: _articles, hasMore: _hasMore));
      }
    } catch (_) {
      emit(NewsError(message: 'Failed to load more articles', canRetry: true));
    }
  }

  Future<void> toggleBookmark(ArticleModel article) async {
    await repository.bookmarkArticle(article);
  }

  Future<void> getBookmarkedArticles() async {
    emit(NewsLoading());
    final articles = await repository.getBookmarkedArticles();
    emit(NewsLoaded(articles: articles, hasMore: false));
  }
}
