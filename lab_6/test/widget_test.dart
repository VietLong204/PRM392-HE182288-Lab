import 'package:flutter_test/flutter_test.dart';
import 'package:lab_6/main.dart';

void main() {
  testWidgets('ResponsiveMovieApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ResponsiveMovieApp());
  });
}
