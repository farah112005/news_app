// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// test/widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/main.dart';
import 'package:news_app/services/news_service.dart';
import 'package:news_app/repositories/news_repository.dart';

void main() {
  testWidgets('App loads', (WidgetTester tester) async {
    final repo = NewsRepository(NewsService());
    await tester.pumpWidget(MyApp(newsRepository: repo));
    expect(find.text('Latest News'), findsOneWidget);
  });
}
