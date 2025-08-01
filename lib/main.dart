import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Screens
import 'views/home_screen.dart';
import 'views/login_screen.dart';
import 'views/register_screen.dart';
import 'views/forgot_password_screen.dart';
import 'views/bookmarks_screen.dart';
import 'views/profile_screen.dart';
import 'views/search_screen.dart';

// Services & Repositories
import 'services/news_service.dart';
import 'repositories/news_repository.dart';
import 'services/local_auth_service.dart';

// Cubits & States
import 'cubits/news_cubit.dart';
import 'cubits/auth_cubit.dart';
import 'cubits/auth_state.dart';
import 'cubits/bookmarks_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = LocalAuthService();
  final authCubit = AuthCubit(authService);
  await authCubit.checkRememberedLogin();

  final newsService = NewsService();
  final newsRepository = NewsRepository(newsService);

  runApp(
    MyApp(
      authCubit: authCubit,
      newsRepository: newsRepository,
      authService: authService,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthCubit authCubit;
  final NewsRepository newsRepository;
  final LocalAuthService authService; // ← أضفنا ده

  const MyApp({
    super.key,
    required this.authCubit,
    required this.newsRepository,
    required this.authService, // ← أضفنا ده
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BookmarksCubit()),
        BlocProvider<AuthCubit>.value(value: authCubit),
        BlocProvider<NewsCubit>(
          create: (_) => NewsCubit(newsRepository)..fetchNews(),
        ),
      ],
      child: MaterialApp(
        title: 'News App',
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (context) => const HomeScreen(),
          '/register': (context) => const RegisterScreen(),
          '/forgot': (context) => const ForgotPasswordScreen(),
          '/bookmarks': (context) => const BookmarksScreen(),
          '/search': (context) => const SearchScreen(),
          '/profile': (context) => ProfileScreen(authService: authService),
        },
        home: const LoginScreen(), // ✅ أول صفحة تظهر
      ),
    );
  }
}
