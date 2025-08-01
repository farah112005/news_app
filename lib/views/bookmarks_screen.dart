import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/bookmarks_cubit.dart';
import '../widgets/article_card.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookmarks = context.watch<BookmarksCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        backgroundColor: Colors.indigo[900],
      ),
      body: bookmarks.isEmpty
          ? const Center(child: Text('لا يوجد أي منشورات محفوظة'))
          : ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                return ArticleCard(article: bookmarks[index]);
              },
            ),
    );
  }
}
