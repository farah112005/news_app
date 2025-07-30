// models/article_model.dart

class ArticleModel {
  final String id;
  final String title;
  final String description;
  final String content;
  final String? imageUrl;
  final DateTime publishedAt;
  final String source;
  final String? author;
  final String url;
  final String category;
  final bool isBookmarked;

  ArticleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.imageUrl,
    required this.publishedAt,
    required this.source,
    required this.author,
    required this.url,
    required this.category,
    this.isBookmarked = false,
  });

  factory ArticleModel.fromJson(
    Map<String, dynamic> json, {
    String category = '',
  }) {
    return ArticleModel(
      id: json['url'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['urlToImage'],
      publishedAt:
          DateTime.tryParse(json['publishedAt'] ?? '') ?? DateTime.now(),
      source: json['source']?['name'] ?? '',
      author: json['author'],
      url: json['url'] ?? '',
      category: category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'imageUrl': imageUrl,
      'publishedAt': publishedAt.toIso8601String(),
      'source': source,
      'author': author,
      'url': url,
      'category': category,
      'isBookmarked': isBookmarked,
    };
  }

  ArticleModel copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    String? imageUrl,
    DateTime? publishedAt,
    String? source,
    String? author,
    String? url,
    String? category,
    bool? isBookmarked,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      source: source ?? this.source,
      author: author ?? this.author,
      url: url ?? this.url,
      category: category ?? this.category,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  @override
  String toString() {
    return 'ArticleModel(title: $title, source: $source, publishedAt: $publishedAt)';
  }
}
