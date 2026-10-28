import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/models/task.dart';

void main() {
  group('Task Model', () {
    test('default completed is false', () {
      final task = Task(id: '1', title: 'Test');
      expect(task.completed, false);
    });

    test('toggle switches completed', () {
      final task = Task(id: '1', title: 'Test');

      task.toggle();
      expect(task.completed, true);

      task.toggle();
      expect(task.completed, false);
    });
  });
}
