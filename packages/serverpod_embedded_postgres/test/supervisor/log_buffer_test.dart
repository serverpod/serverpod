import 'package:serverpod_embedded_postgres/src/supervisor/log_buffer.dart';
import 'package:test/test.dart';

void main() {
  group('Given a LogBuffer', () {
    test('when fewer than capacity lines are added then all are retained.', () {
      var buf = LogBuffer(capacity: 5);

      buf.add('a');
      buf.add('b');
      buf.add('c');

      expect(buf.snapshot(), ['a', 'b', 'c']);
    });

    test(
      'when more than capacity lines are added '
      'then the oldest are evicted in FIFO order.',
      () {
        var buf = LogBuffer(capacity: 3);

        buf.add('a');
        buf.add('b');
        buf.add('c');
        buf.add('d');
        buf.add('e');

        expect(buf.snapshot(), ['c', 'd', 'e']);
      },
    );
  });
}
