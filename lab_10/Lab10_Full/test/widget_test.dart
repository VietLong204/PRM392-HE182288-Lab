import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_full/main.dart';

void main() {
  testWidgets('Lab10_Full smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Lab 10: Final Integrated Project'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump();
  });
}
