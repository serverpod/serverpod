import 'package:serverpod_cli/src/commands/tui/bounded_queue_list.dart';
import 'package:test/test.dart';

void main() {
  group('Given a BoundedQueueList with maxLength 3', () {
    late BoundedQueueList<int> list;

    setUp(() {
      list = BoundedQueueList<int>(3);
    });

    test('when adding within limit then keeps all elements', () {
      list.add(1);
      list.add(2);
      expect(list, [1, 2]);
    });

    test('when exceeding limit then drops oldest', () {
      list.add(1);
      list.add(2);
      list.add(3);
      list.add(4);
      expect(list, [2, 3, 4]);
    });

    test('when addAll exceeds limit then drops oldest', () {
      list.addAll([1, 2, 3, 4, 5]);
      expect(list, [3, 4, 5]);
    });

    test('when addAll on non-empty list then trims total', () {
      list.add(1);
      list.addAll([2, 3, 4]);
      expect(list, [2, 3, 4]);
    });
  });
}
