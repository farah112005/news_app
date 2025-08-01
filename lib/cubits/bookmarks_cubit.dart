import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/article_model.dart';

class BookmarksCubit extends Cubit<List<ArticleModel>> {
  BookmarksCubit() : super([]);

  void addToBookmarks(ArticleModel article) {
    if (!state.contains(article)) {
      emit([...state, article]);
    }
  }

  void removeFromBookmarks(ArticleModel article) {
    emit(state.where((a) => a != article).toList());
  }

  bool isBookmarked(ArticleModel article) {
    return state.contains(article);
  }
}
