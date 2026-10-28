import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/repositories/task_repository.dart';
import 'package:taskly/screens/task_list_screen.dart';

void main() {
  group('Task Integration Flow', () {
    testWidgets('add, edit, save full flow', (tester) async {
      final repository = TaskRepository();

      await tester.pumpWidget(
        MaterialApp(
          home: TaskListScreen(repository: repository),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Original title');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();
      expect(find.text('Original title'), findsOneWidget);

      await tester.tap(find.text('Original title'));
      await tester.pumpAndSettle();
      expect(find.text('Task Detail'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('detailTitleField')), 'Updated title');
      await tester.pump();

      await tester.tap(find.byKey(const Key('saveButton')));
      await tester.pumpAndSettle();

      expect(find.text('Updated title'), findsOneWidget);
      expect(find.text('Original title'), findsNothing);
    });
  });
}
