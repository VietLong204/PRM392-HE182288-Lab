import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_5_notification/main.dart';

void main() {
  testWidgets('Lab10_5 smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Lab 10.5: Local Notification'), findsOneWidget);
  });
}
