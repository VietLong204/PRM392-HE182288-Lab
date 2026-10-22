import 'package:flutter_test/flutter_test.dart';
import 'package:lab8_networking/main.dart';

void main() {
  testWidgets('Lab8App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const Lab8App());
  });
}
