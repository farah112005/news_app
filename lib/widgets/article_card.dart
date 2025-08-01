import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../models/article_model.dart';
import '../cubits/bookmarks_cubit.dart';

class ArticleCard extends StatefulWidget {
  final ArticleModel article;

  const ArticleCard({required this.article, super.key});

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    final isBookmarked = context.watch<BookmarksCubit>().isBookmarked(
      widget.article,
    );

    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.article.imageUrl != null &&
              widget.article.imageUrl!.isNotEmpty)
            Image.network(widget.article.imageUrl!),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              widget.article.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              widget.article.source,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : null,
                ),
                onPressed: () {
                  setState(() {
                    isLiked = !isLiked;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isLiked ? 'تم الإعجاب بالمنشور' : 'تم إلغاء الإعجاب',
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  Share.share(widget.article.url);
                },
              ),
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked ? Colors.grey : null,
                ),
                onPressed: () {
                  final cubit = context.read<BookmarksCubit>();
                  if (isBookmarked) {
                    cubit.removeFromBookmarks(widget.article);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم إزالة المنشور من المفضلة'),
                      ),
                    );
                  } else {
                    cubit.addToBookmarks(widget.article);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم الحفظ في المفضلة')),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
