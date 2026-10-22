import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_4_firebase_google_sign_in/main.dart';

void main() {
  testWidgets('Lab10_4 smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Lab 10.4: Google Sign-In'), findsOneWidget);
  });
}
