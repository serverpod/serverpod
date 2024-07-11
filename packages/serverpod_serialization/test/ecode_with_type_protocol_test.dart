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

class _TestProtocol extends SerializationManager {
  @override
  String? getClassNameForObject(Object? data) {
    if (data is _User) return '_User';
    if (data is List<_User>) return 'List<_User>';
    if (data is List<Map<String, Object>>) return 'List<Map<String, Object>>';
    if (data is Map<String, _User>) return 'Map<String, _User>';
    if (data is Map<String, Object>) return 'Map<String, Object>';
    if (data is Map<String, List<_User>>) return 'Map<String, List<_User>>';
    return super.getClassNameForObject(data);
  }
}

void main() {
  var protocol = _TestProtocol();

  group('Given a user object with a server-only password field,', () {
    _User user = _User(name: 'John', password: '123');

    test(
      'when encoded using encodeForProtocolWithType method, then the password field is excluded from the output',
      () {
        var stringifiedJson = protocol.encodeForProtocolWithType(user);
        expect(stringifiedJson, isNot(contains('password')));
      },
    );

    test(
      'when a list of user objects is encoded using encodeForProtocolWithType method, then the password fields are excluded from the output',
      () {
        var userList = [user];
        var stringifiedJson = protocol.encodeForProtocolWithType(userList);
        expect(stringifiedJson, isNot(contains('password')));
      },
    );

    test(
      'when a map containing a user object is encoded using encodeForProtocolWithType method, then the password field is excluded from the output',
      () {
        var userMap = {'user': user};
        var stringifiedJson = protocol.encodeForProtocolWithType(userMap);
        expect(stringifiedJson, isNot(contains('password')));
      },
    );

    test(
      'when a map containing a list of user objects is encoded using encodeForProtocolWithType method, then the password fields are excluded from the output',
      () {
        var userMap = {
          'users': [user]
        };
        var stringifiedJson = protocol.encodeForProtocolWithType(userMap);
        expect(stringifiedJson, isNot(contains('password')));
      },
    );
  });

  group(
      'Given a map with a complex nested structure containing objects with server-only password fields,',
      () {
    _User user = _User(name: 'John', password: '123');

    test(
      'when encoded using encodeForProtocolWithType method, then the password fields are excluded from the output',
      () {
        var map = {
          'list': [user],
          'nestedMap': {
            'innerUser': user,
            'innerList': [user]
          },
        };
        var stringifiedJson = protocol.encodeForProtocolWithType(map);
        expect(stringifiedJson, isNot(contains('password')));
      },
    );
  });

  group(
      'Given a list with a complex nested structure containing objects with server-only password fields,',
      () {
    _User user = _User(name: 'John', password: '123');

    test(
      'when encoded using encodeForProtocolWithType method, then the password fields are excluded from the output',
      () {
        var list = [
          {'user': user},
          {
            'nestedMap': {
              'innerUser': user,
              'innerList': [user]
            }
          }
        ];
        var stringifiedJson = protocol.encodeForProtocolWithType(list);
        expect(stringifiedJson, isNot(contains('password')));
      },
    );
  });
}
