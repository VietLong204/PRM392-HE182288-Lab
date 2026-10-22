import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_3_auto_login_logout/main.dart';

void main() {
  testWidgets('Lab10_3 smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Lab 10.3: Auto Login & Logout'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump();
  });
}
