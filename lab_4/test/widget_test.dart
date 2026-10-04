import 'package:flutter_test/flutter_test.dart';
import 'package:lab_4/main.dart';

void main() {
  testWidgets('Lab 4 Main Screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const Lab4App());

    // Verify that the exercises exist in the list.
    expect(find.text('Exercise 1 – Core Widgets Demo'), findsOneWidget);
    expect(find.text('Exercise 2 – Input Controls Demo'), findsOneWidget);
    expect(find.text('Exercise 3 – Layout Demo'), findsOneWidget);
    expect(find.text('Exercise 4 – App Structure & Theme'), findsOneWidget);
    expect(find.text('Exercise 5 – Common UI Fixes'), findsOneWidget);
  });
}
