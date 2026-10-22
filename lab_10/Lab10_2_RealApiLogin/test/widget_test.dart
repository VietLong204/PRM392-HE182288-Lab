import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_2_real_api_login/main.dart';

void main() {
  testWidgets('Lab10_2 smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Lab 10.2: Real API Login'), findsOneWidget);
  });
}
