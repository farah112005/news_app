import 'package:equatable/equatable.dart';
import '../models/article_model.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<ArticleModel> articles;
  final bool hasMore;

  const NewsLoaded({required this.articles, required this.hasMore});

  @override
  List<Object?> get props => [articles, hasMore];
}

class NewsRefreshing extends NewsState {}

class NewsEmpty extends NewsState {
  final String message;

  const NewsEmpty({required this.message});

  @override
  List<Object?> get props => [message];
}

class NewsError extends NewsState {
  final String message;
  final bool canRetry;

  const NewsError({required this.message, this.canRetry = true});

  @override
  List<Object?> get props => [message, canRetry];
}

class NewsOffline extends NewsState {
  final List<ArticleModel> cachedArticles;

  const NewsOffline({required this.cachedArticles});

  @override
  List<Object?> get props => [cachedArticles];
}
