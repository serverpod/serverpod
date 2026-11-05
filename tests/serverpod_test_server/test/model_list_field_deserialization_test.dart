import 'package:serverpod_test_client/serverpod_test_client.dart' as client;
import 'package:serverpod_test_server/src/generated/protocol.dart' as server;
import 'package:test/test.dart';

void main() {
  group('Given the json of an exception with a List field of a model', () {
    var json = server.ExceptionWithModelList(
      message: 'Invalid input',
      details: [
        server.ExceptionDetail(field: 'email', message: 'Required'),
        server.ExceptionDetail(field: 'name', message: 'Too long'),
      ],
    ).toJson();

    test('when deserializing it with the server protocol '
        'then the list is restored.', () {
      var exception = server.Protocol()
          .deserialize<server.ExceptionWithModelList>(json);

      expect(exception.details, hasLength(2));
      expect(exception.details[0].field, 'email');
      expect(exception.details[1].message, 'Too long');
    });

    test('when deserializing it by class name with the client protocol '
        'then the list is restored.', () {
      var exception = client.Protocol().deserializeByClassName({
        'className': 'ExceptionWithModelList',
        'data': json,
      });

      expect(exception, isA<client.ExceptionWithModelList>());
      exception as client.ExceptionWithModelList;
      expect(exception.details, hasLength(2));
      expect(exception.details[0].field, 'email');
      expect(exception.details[1].message, 'Too long');
    });
  });

  group('Given the json of a model whose sealed parent has a List field of '
      'a model', () {
    var json = server.SealedListChild(
      items: [
        server.SealedListItem(value: 'first'),
        server.SealedListItem(value: 'second'),
      ],
      name: 'child',
    ).toJson();

    test('when deserializing it with the server protocol '
        'then the list is restored.', () {
      var child = server.Protocol().deserialize<server.SealedListChild>(json);

      expect(child.items, hasLength(2));
      expect(child.items[0].value, 'first');
      expect(child.name, 'child');
    });

    test('when deserializing it by class name with the client protocol '
        'then the list is restored.', () {
      var child = client.Protocol().deserializeByClassName({
        'className': 'SealedListChild',
        'data': json,
      });

      expect(child, isA<client.SealedListChild>());
      child as client.SealedListChild;
      expect(child.items, hasLength(2));
      expect(child.items[1].value, 'second');
      expect(child.name, 'child');
    });
  });
}
