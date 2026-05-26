import 'package:serverpod_serialization/src/serialization.dart';
import 'package:test/test.dart';

class _TestProtocol extends SerializationManager {}

void main() {
  var protocol = _TestProtocol();

  test(
    'Given a list of integers when calling wrapWithClassName then it throws ArgumentError',
    () {
      var list = [1, 2, 3];
      expect(
        () => protocol.wrapWithClassName(list),
        throwsArgumentError,
      );
    },
  );

  test(
    'Given a list of strings when calling wrapWithClassName then it throws ArgumentError',
    () {
      var list = ['a', 'b', 'c'];
      expect(
        () => protocol.wrapWithClassName(list),
        throwsArgumentError,
      );
    },
  );

  test(
    'Given a map of string keys and integer values when calling wrapWithClassName then it throws ArgumentError',
    () {
      var map = {'one': 1, 'two': 2};
      expect(
        () => protocol.wrapWithClassName(map),
        throwsArgumentError,
      );
    },
  );

  test(
    'Given a map of integer keys and string values when calling wrapWithClassName then it throws ArgumentError',
    () {
      var map = {1: 'one', 2: 'two'};
      expect(
        () => protocol.wrapWithClassName(map),
        throwsArgumentError,
      );
    },
  );

  test(
    'Given a map of string keys and list values when calling wrapWithClassName then it throws ArgumentError',
    () {
      var map = {
        'numbers': [1, 2, 3],
      };
      expect(
        () => protocol.wrapWithClassName(map),
        throwsArgumentError,
      );
    },
  );

  test(
    'Given a list of maps when calling wrapWithClassName then it throws ArgumentError',
    () {
      var list = [
        {'one': 1},
        {'two': 2},
      ];
      expect(
        () => protocol.wrapWithClassName(list),
        throwsArgumentError,
      );
    },
  );
}
