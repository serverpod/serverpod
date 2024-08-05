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
    return super.getClassNameForObject(data);
  }
}

void main() {
  var protocol = _TestProtocol();

  test(
    'Given a user object with a server-only password field, when encoded using encodeWithTypeForProtocol method, then the password field is excluded from the output',
    () {
      _User user = _User(name: 'John', password: '123');
      var stringifiedJson = protocol.encodeWithTypeForProtocol(user);
      expect(stringifiedJson, isNot(contains('password')));
    },
  );
}
