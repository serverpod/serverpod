import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

void main() {
  test('Given json data when encoded to string then output is stringified json',
      () {
    var jsonData = {'a': 1, 'b': 2};

    var stringifiedJson = SerializationManager.encode(jsonData);
    expect(stringifiedJson, '{"a":1,"b":2}');
  });

  test(
      'Given json data when encoded to formatted string then output is formatted stringified json',
      () {
    var jsonData = {'a': 1, 'b': 2};

    var stringifiedJson = SerializationManager.encode(
      jsonData,
      formatted: true,
    );
    expect(stringifiedJson, '''
{
  "a": 1,
  "b": 2
}''');
  });

  test('respect ProtocolSerialization even in List/Map', () {
    var user = _User(name: 'John', password: '123');
    var userList = [user];
    var userMap = {'user': user, 'users': userList};

    var stringifiedJson = SerializationManager.encode(user);
    expect(true, stringifiedJson.contains('password'));

    stringifiedJson = SerializationManager.encodeForProtocol(user);
    expect(false, stringifiedJson.contains('password'));

    stringifiedJson = SerializationManager.encode(userMap);
    expect(true, stringifiedJson.contains('password'));

    stringifiedJson = SerializationManager.encodeForProtocol(userMap);
    expect(false, stringifiedJson.contains('password'));
  });
}

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
