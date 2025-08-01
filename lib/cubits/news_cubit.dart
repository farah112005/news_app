// lib/cubits/news_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/news_repository.dart';
import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsRepository repository;

  NewsCubit(this.repository) : super(NewsInitial());

  Future<void> fetchNews() async {
    emit(NewsLoading());
    try {
      final articles = await repository.fetchTopHeadlines();
      emit(NewsLoaded(articles));
    } catch (e) {
      emit(NewsError('Failed to fetch news'));
    }
  }
}
