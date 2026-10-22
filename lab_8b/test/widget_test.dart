import 'package:flutter_test/flutter_test.dart';
import 'package:lab8b_movie_explorer/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
  });
}
