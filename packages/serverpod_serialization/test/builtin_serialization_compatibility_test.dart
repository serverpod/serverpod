import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given an integer envelope and a manager overriding integer deserialization, '
    'when decoding by class name, '
    'then the override determines the decoded value.',
    () {
      final protocol = _IntegerProtocol();
      final envelope = {
        'className': 'int',
        'data': 7,
      };

      final result = protocol.deserializeByClassName(envelope);

      expect(result, 70);
    },
  );

  test(
    'Given a list envelope and a manager overriding dynamic field decoding, '
    'when decoding by class name, '
    'then every element uses the custom decoder.',
    () {
      final protocol = _DynamicProtocol();
      final envelope = {
        'className': 'List',
        'data': [1, 2],
      };

      final result = protocol.deserializeByClassName(envelope);

      expect(result, [10, 20]);
    },
  );

  test(
    'Given a set envelope and a manager overriding dynamic field decoding, '
    'when decoding by class name, '
    'then every element uses the custom decoder.',
    () {
      final protocol = _DynamicProtocol();
      final envelope = {
        'className': 'Set',
        'data': [1, 2, 1],
      };

      final result = protocol.deserializeByClassName(envelope);

      expect(result, {10, 20});
    },
  );

  test(
    'Given a string-keyed map envelope and a manager overriding dynamic field decoding, '
    'when decoding by class name, '
    'then values use the custom decoder and keys remain unchanged.',
    () {
      final protocol = _DynamicProtocol();
      final envelope = {
        'className': 'Map',
        'data': {'first': 1, 'second': 2},
      };

      final result = protocol.deserializeByClassName(envelope);

      expect(result, {'first': 10, 'second': 20});
    },
  );

  test(
    'Given an entry-list map envelope and a manager overriding dynamic field decoding, '
    'when decoding by class name, '
    'then both keys and values use the custom decoder.',
    () {
      final protocol = _DynamicProtocol();
      final envelope = {
        'className': 'Map',
        'data': [
          {'k': 1, 'v': 2},
        ],
      };

      final result = protocol.deserializeByClassName(envelope);

      expect(result, {10: 20});
    },
  );

  test(
    'Given a list envelope with a non-list payload, '
    'when decoding by class name, '
    'then the existing class-name error identifies List.',
    () {
      final protocol = _Protocol();
      final envelope = {'className': 'List', 'data': 7};

      expect(
        () => protocol.deserializeByClassName(envelope),
        throwsA(
          isA<DeserializationClassNameNotFoundException>().having(
            (error) => error.className,
            'className',
            'List',
          ),
        ),
      );
    },
  );

  test(
    'Given a set envelope with a non-list payload, '
    'when decoding by class name, '
    'then the existing class-name error identifies Set.',
    () {
      final protocol = _Protocol();
      final envelope = {'className': 'Set', 'data': 7};

      expect(
        () => protocol.deserializeByClassName(envelope),
        throwsA(
          isA<DeserializationClassNameNotFoundException>().having(
            (error) => error.className,
            'className',
            'Set',
          ),
        ),
      );
    },
  );

  test(
    'Given a map envelope with neither a map nor an entry list, '
    'when decoding by class name, '
    'then the existing class-name error identifies Map.',
    () {
      final protocol = _Protocol();
      final envelope = {'className': 'Map', 'data': 7};

      expect(
        () => protocol.deserializeByClassName(envelope),
        throwsA(
          isA<DeserializationClassNameNotFoundException>().having(
            (error) => error.className,
            'className',
            'Map',
          ),
        ),
      );
    },
  );
}

class _Protocol extends SerializationManager {}

class _IntegerProtocol extends SerializationManager {
  @override
  T deserialize<T>(dynamic data, [Type? t]) {
    if ((t ?? T) == int) return ((data as int) * 10) as T;

    return super.deserialize<T>(data, t);
  }
}

class _DynamicProtocol extends SerializationManager {
  @override
  dynamic deserializeDynamicFieldValue(Object? value) => (value as int) * 10;
}
