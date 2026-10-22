import 'package:flutter_test/flutter_test.dart';
import 'package:lab_7/main.dart';

void main() {
  testWidgets('SignupScreen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Signup'), findsOneWidget);
  });
}
