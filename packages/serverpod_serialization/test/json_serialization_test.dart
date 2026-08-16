import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

class _User implements SerializableModel, ProtocolSerialization {
  final String name;
  final String password;

  _User({
    required this.name,
    required this.password,
  });

  @override
  Map<String, String> toJson() {
    return {
      'name': name,
      'password': password,
    };
  }

  @override
  Map<String, String> toJsonForProtocol() {
    return {
      'name': name,
    };
  }
}

void main() {
  test(
    'Given simple JSON data, when encoded using encode method, then output is stringified JSON',
    () {
      var jsonData = {'a': 1, 'b': 2};
      var stringifiedJson = SerializationManager.encode(jsonData);
      expect(stringifiedJson, '{"a":1,"b":2}');
    },
  );

  test(
    'Given simple JSON data, when encoded using encode method with formatting, then output is formatted stringified JSON',
    () {
      var jsonData = {'a': 1, 'b': 2};
      var stringifiedJson = SerializationManager.encode(
        jsonData,
        formatted: true,
      );
      expect(
        stringifiedJson,
        '''
{
  "a": 1,
  "b": 2
}''',
      );
    },
  );

  group('Given user object with server only password field,', () {
    _User user = _User(name: 'John', password: '123');

    test(
      'when encoded using encodeForProtocol method, then password is excluded from the output',
      () {
        var stringifiedJson = SerializationManager.encodeForProtocol(user);
        expect(stringifiedJson, isNot(contains('password')));
      },
    );

    test(
      'when a list of user objects is encoded using encodeForProtocol method, then passwords are excluded from the output',
      () {
        var userList = [user];
        var stringifiedJson = SerializationManager.encodeForProtocol(userList);
        expect(stringifiedJson, isNot(contains('password')));
      },
    );

    test(
      'when a map containing a user object is encoded using encodeForProtocol method, then password is excluded from the output',
      () {
        var userMap = {'user': user};
        var stringifiedJson = SerializationManager.encodeForProtocol(userMap);
        expect(stringifiedJson, isNot(contains('password')));
      },
    );

    test(
      'when a map containing a list of user objects is encoded using encodeForProtocol method, then passwords are excluded from the output',
      () {
        var userMap = {
          'users': [user],
        };
        var stringifiedJson = SerializationManager.encodeForProtocol(userMap);
        expect(stringifiedJson, isNot(contains('password')));
      },
    );
  });

  group('Given a list of primitives,', () {
    var primitiveList = [1, 2.5, 'hello', true];

    test(
      'when encoded using encodeForProtocol method, then output matches the input list',
      () {
        var stringifiedJson = SerializationManager.encodeForProtocol(
          primitiveList,
        );
        expect(stringifiedJson, '[1,2.5,"hello",true]');
      },
    );
  });

  group('Given a map of primitives,', () {
    var primitiveMap = {'a': 1, 'b': 2.5, 'c': 'hello', 'd': true};

    test(
      'when encoded using encodeForProtocol method, then output matches the input map',
      () {
        var stringifiedJson = SerializationManager.encodeForProtocol(
          primitiveMap,
        );
        expect(stringifiedJson, '{"a":1,"b":2.5,"c":"hello","d":true}');
      },
    );
  });

  group(
    'Given a map with complex nested structure containing object with server only password field,',
    () {
      _User user = _User(name: 'John', password: '123');

      test(
        'when encoded using encodeForProtocol method, then passwords are excluded from the output',
        () {
          var map = {
            'list': [user],
            'nestedMap': {
              'innerUser': user,
              'innerList': [user],
            },
          };
          var stringifiedJson = SerializationManager.encodeForProtocol(map);
          expect(stringifiedJson, isNot(contains('password')));
        },
      );
    },
  );

  group(
    'Given a list with complex nested structure containing object with server only password field,',
    () {
      _User user = _User(name: 'John', password: '123');

      test(
        'when encoded using encodeForProtocol method, then passwords are excluded from the output',
        () {
          var list = [
            {'user': user},
            {
              'nestedMap': {
                'innerUser': user,
                'innerList': [user],
              },
            },
          ];
          var stringifiedJson = SerializationManager.encodeForProtocol(list);
          expect(stringifiedJson, isNot(contains('password')));
        },
      );
    },
  );
}
