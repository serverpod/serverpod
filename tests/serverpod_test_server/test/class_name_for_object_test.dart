import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart'
    as auth_client;
import 'package:serverpod_auth_server/serverpod_auth_server.dart'
    as auth_server;
import 'package:serverpod_test_client/serverpod_test_client.dart' as client;
import 'package:serverpod_test_server/src/generated/protocol.dart' as server;
import 'package:test/test.dart';

void main() {
  var serverProtocol = server.Protocol();
  var clientProtocol = client.Protocol();

  test(
      'Given a Set with `int`s, when "getClassNameForObject" is called, then both server and client generate the same identifier',
      () {
    var serverName = serverProtocol.getClassNameForObject(
      <int>{1},
    );
    var clientName = clientProtocol.getClassNameForObject(
      <int>{1},
    );

    expect(serverName, 'Set<int>');
    expect(clientName, serverName);
  });

  test(
      'Given a serialized `Set<int>`, when "deserializeByClassName" is called, then both server and client can decode the data',
      () {
    var serialized = {
      'className': 'Set<int>',
      'data': [1, 2, 3]
    };

    var serverResult = serverProtocol.deserializeByClassName(serialized);

    expect(serverResult, {1, 2, 3});

    var clientResult = clientProtocol.deserializeByClassName(serialized);

    expect(clientResult, {1, 2, 3});
  });

  test(
      'Given a serialized record `(int?,)?`, when "deserializeByClassName" is called, then both server and client can decode the data',
      () {
    var serialized = {
      'className': '(int?,)?',
      'data': {
        'p': [1234],
      },
    };

    var serverResult = serverProtocol.deserializeByClassName(serialized);

    expect(serverResult, (1234,));

    var clientResult = clientProtocol.deserializeByClassName(serialized);

    expect(clientResult, (1234,));
  });

  test(
      'Given a list with a type from another module, when "getClassNameForObject" is called, then both server and client generate the same string with the module name included',
      () {
    var serverName = serverProtocol.getClassNameForObject(
      <auth_server.UserInfo>[],
    );
    var clientName = clientProtocol.getClassNameForObject(
      <auth_client.UserInfo>[],
    );

    expect(serverName, 'List<serverpod_auth.UserInfo>');
    expect(clientName, serverName);
  });

  test(
      'Given a hierarchy of model classes, when "getClassNameForObject" is called, then both server and client generate the same string for each class.',
      () {
    final modelClassesWithname = <String,
        (SerializableModel clientModel, SerializableModel serverModel)>{
      'GrandparentClass': (
        client.GrandparentClass(grandParentField: ''),
        server.GrandparentClass(grandParentField: ''),
      ),
      'ParentClass': (
        client.ParentClass(grandParentField: '', parentField: ''),
        server.ParentClass(grandParentField: '', parentField: ''),
      ),
      'ChildClass': (
        client.ChildClass(grandParentField: '', parentField: '', childField: 0),
        server.ChildClass(grandParentField: '', parentField: '', childField: 0),
      ),
    };

    for (final MapEntry(key: className, value: cases)
        in modelClassesWithname.entries) {
      var clientName = clientProtocol.getClassNameForObject(cases.$1);
      var serverName = serverProtocol.getClassNameForObject(cases.$2);

      expect(serverName, className);
      expect(clientName, serverName);
    }
  });

  test(
      'Given a serialized data from another module, when "deserializeByClassName" is called, then both server and client can decode the data`',
      () {
    var serialized = {
      'className': 'List<serverpod_auth.UserInfo>',
      'data': [
        {
          'userIdentifier': 'user1',
          'created': '2024-12-24',
          'scopeNames': [],
          'blocked': false,
        }
      ]
    };

    var serverResult = serverProtocol.deserializeByClassName(serialized);

    expect(
      serverResult,
      [
        isA<auth_server.UserInfo>()
            .having((u) => u.userIdentifier, 'userIdentifier', 'user1'),
      ],
    );

    var clientResult = clientProtocol.deserializeByClassName(serialized);

    expect(
      clientResult,
      [
        isA<auth_client.UserInfo>()
            .having((u) => u.userIdentifier, 'userIdentifier', 'user1'),
      ],
    );
  });
}
