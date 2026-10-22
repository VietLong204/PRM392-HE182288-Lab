import 'package:flutter_test/flutter_test.dart';
import 'package:lab_9/main.dart';

void main() {
  testWidgets('Lab9App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const Lab9App());
    expect(find.text('9.1 Assets'), findsOneWidget);
    expect(find.text('9.2 Storage'), findsOneWidget);
    expect(find.text('9.3 CRUD DB'), findsOneWidget);
  });
}
