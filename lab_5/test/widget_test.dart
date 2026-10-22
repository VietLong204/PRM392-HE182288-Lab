import 'package:flutter_test/flutter_test.dart';
import 'package:lab_5/main.dart';

void main() {
  testWidgets('MovieApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MovieApp());
  });
}
