import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

void main() {
  var client = Client('http://localhost:8080/');

  group('Given a client with multiple endpoints', () {
    test('when getEndpointOfType is called with a unique endpoint type '
        'then it returns the correct endpoint.', () {
      var endpoint = client.getEndpointOfType<EndpointIndependent>();
      expect(endpoint, isA<EndpointIndependent>());
      expect(endpoint.name, 'independent');
    });

    test('when getEndpointOfType is called with EndpointRef type '
        'then it throws StateError due to multiple matches.', () {
      expect(
        () => client.getEndpointOfType<EndpointRef>(),
        throwsA(isA<ServerpodClientMultipleEndpointsFound>()),
      );
    });

    test('when getEndpointOfType is called with a non-existent endpoint type '
        'then it throws StateError due to no matches.', () {
      expect(
        () => client.getEndpointOfType<NonExistentEndpoint>(),
        throwsA(
          isA<ServerpodClientEndpointNotFound>().having(
            (e) => e.message,
            'message',
            'No endpoint of type "NonExistentEndpoint" found.',
          ),
        ),
      );
    });
  });

  group('Given a client with endpoints that share a common base type', () {
    test(
      'when getEndpointOfType is called with an abstract base type that has a single subclass '
      'then it returns the correct endpoint.',
      () {
        var endpoint = client.getEndpointOfType<EndpointAbstractSubClass>();
        expect(endpoint, isA<EndpointConcreteSubClass>());
        expect(endpoint.name, 'concreteSubClass');
      },
    );

    test(
      'when getEndpointOfType is called with a concrete subclass type that has no subclasses '
      'then it returns the correct endpoint.',
      () {
        var endpoint = client.getEndpointOfType<EndpointConcreteSubClass>();
        expect(endpoint, isA<EndpointConcreteSubClass>());
        expect(endpoint.name, 'concreteSubClass');
      },
    );

    test(
      'when getEndpointOfType is called with an abstract base type that has multiple subclasses '
      'then it throws StateError due to multiple matches.',
      () {
        expect(
          () => client.getEndpointOfType<EndpointAbstractBase>(),
          throwsA(
            isA<ServerpodClientMultipleEndpointsFound>().having(
              (e) => e.message,
              'message',
              'Found 2 endpoints of type "EndpointAbstractBase": "concreteBase", '
                  '"concreteSubClass". Use the name parameter to disambiguate.',
            ),
          ),
        );
      },
    );

    test(
      'when getEndpointOfType is called with a valid name and an abstract base type that has multiple subclasses '
      'then it returns the correct endpoint.',
      () {
        var endpoint = client.getEndpointOfType<EndpointAbstractBase>(
          'concreteBase',
        );
        expect(endpoint, isA<EndpointConcreteBase>());
        expect(endpoint.name, 'concreteBase');
      },
    );

    test(
      'when getEndpointOfType is called with valid name and a concrete base type that has multiple subclasses '
      'then it returns the correct endpoint.',
      () {
        var endpoint = client.getEndpointOfType<EndpointConcreteBase>(
          'concreteBase',
        );
        expect(endpoint, isA<EndpointConcreteBase>());
        expect(endpoint.name, 'concreteBase');
      },
    );
  });
}

/// A non-existent endpoint type for testing error cases.
abstract class NonExistentEndpoint extends EndpointRef {
  NonExistentEndpoint(super.caller);
}
