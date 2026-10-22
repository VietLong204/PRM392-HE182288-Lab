import 'package:flutter_test/flutter_test.dart';
import 'package:hello_flutter_lab1/main.dart';

void main() {
  testWidgets('Lab 1 loads successfully test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title and welcome text are present.
    expect(find.text('Lab 1 Demo'), findsOneWidget);
    expect(find.text('Hello Flutter World!'), findsOneWidget);
  });
}
