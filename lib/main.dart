import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'cubits/auth_cubit.dart';
import 'cubits/news_cubit.dart';
import 'repositories/news_repository.dart';
import 'services/news_service.dart';

import 'views/login_screen.dart';
import 'views/register_screen.dart';
import 'views/forgot_password_screen.dart';
import 'views/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final newsRepository = NewsRepository(newsService: NewsService());

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()..checkAuthStatus()),
        BlocProvider<NewsCubit>(create: (_) => NewsCubit(newsRepository)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News App',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: Colors.grey[200],
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        initialRoute: '/login',
        routes: {
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/forgot': (_) => const ForgotPasswordScreen(),
          '/home': (_) => const HomeScreen(),
        },
      ),
    );
  }
}
