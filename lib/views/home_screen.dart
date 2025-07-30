// views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubits/news_cubit.dart';
import 'package:news_app/cubits/news_state.dart';
import 'package:news_app/models/category_model.dart';
import 'package:news_app/widgets/article_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late NewsCubit newsCubit;
  final ScrollController _scrollController = ScrollController();
  List<CategoryModel> categories = [
    CategoryModel(
      id: '1',
      name: 'business',
      displayName: 'Business',
      icon: Icons.business,
      color: Colors.blue,
    ),
    CategoryModel(
      id: '2',
      name: 'entertainment',
      displayName: 'Entertainment',
      icon: Icons.movie,
      color: Colors.red,
    ),
    CategoryModel(
      id: '3',
      name: 'health',
      displayName: 'Health',
      icon: Icons.health_and_safety,
      color: Colors.green,
    ),
    CategoryModel(
      id: '4',
      name: 'science',
      displayName: 'Science',
      icon: Icons.science,
      color: Colors.orange,
    ),
    CategoryModel(
      id: '5',
      name: 'sports',
      displayName: 'Sports',
      icon: Icons.sports_soccer,
      color: Colors.purple,
    ),
    CategoryModel(
      id: '6',
      name: 'technology',
      displayName: 'Tech',
      icon: Icons.devices,
      color: Colors.teal,
    ),
  ];
  String selectedCategory = 'business';

  @override
  void initState() {
    super.initState();
    newsCubit = context.read<NewsCubit>();
    newsCubit.fetchByCategory(selectedCategory);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        newsCubit.loadMoreArticles(selectedCategory);
      }
    });
  }

  Future<void> _onRefresh() async {
    await newsCubit.refreshNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome, Farah 👋"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to search
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(child: Text('User Info')),
            ListTile(leading: Icon(Icons.bookmark), title: Text('Bookmarks')),
            ListTile(leading: Icon(Icons.logout), title: Text('Logout')),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = cat.name == selectedCategory;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 10,
                  ),
                  child: ChoiceChip(
                    label: Text(cat.displayName),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        selectedCategory = cat.name;
                      });
                      newsCubit.fetchByCategory(selectedCategory);
                    },
                    selectedColor: cat.color.withOpacity(0.3),
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(
                      color: isSelected ? cat.color : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<NewsCubit, NewsState>(
              builder: (context, state) {
                if (state is NewsLoading || state is NewsInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is NewsLoaded) {
                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: state.articles.length,
                      itemBuilder: (context, index) {
                        final article = state.articles[index];
                        return ArticleCard(
                          article: article,
                          onTap: () {
                            // Navigate to detail screen
                          },
                          onBookmark: () {
                            newsCubit.toggleBookmark(article);
                          },
                          onShare: () {
                            // Share article
                          },
                        );
                      },
                    ),
                  );
                } else if (state is NewsEmpty) {
                  return Center(child: Text(state.message));
                } else if (state is NewsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message),
                        const SizedBox(height: 10),
                        if (state.canRetry)
                          ElevatedButton(
                            onPressed: () {
                              newsCubit.fetchByCategory(selectedCategory);
                            },
                            child: const Text('Retry'),
                          ),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: Text("Something went wrong"));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Search button action
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}
