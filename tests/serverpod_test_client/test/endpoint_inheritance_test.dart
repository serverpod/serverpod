import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_module_client/serverpod_test_module_client.dart'
    as m;
import 'package:test/test.dart';

void main() {
  var client = Client('http://localhost:8080/');

  test(
    'Given an abstract base endpoint class then it is subclass of EndpointRef.',
    () {
      expect(isSubClass<EndpointAbstractBase, EndpointRef>(), isTrue);
    },
  );

  group(
    'Given a concrete endpoint instance that extends an abstract endpoint class',
    () {
      var endpoint = EndpointConcreteBase(client);

      test('then it is subclass of the generated abstract class.', () {
        expect(endpoint, isA<EndpointAbstractBase>());
      });

      test('then its name is correct.', () {
        expect(endpoint.name, 'concreteBase');
      });

      test('then it is initialized correctly on the client.', () {
        expect(client.concreteBase, isA<EndpointConcreteBase>());
      });
    },
  );

  test(
    'Given an abstract endpoint class that extends a concrete endpoint class '
    'then it is subclass of the generated concrete endpoint class.',
    () {
      expect(
        isSubClass<EndpointAbstractSubClass, EndpointConcreteBase>(),
        isTrue,
      );
    },
  );

  group(
    'Given an instance of abstract > concrete > abstract subclass > concrete subclass endpoint class hierarchy',
    () {
      var endpoint = EndpointConcreteSubClass(client);

      test('then it is subclass of the abstract generated subclass.', () {
        expect(endpoint, isA<EndpointAbstractSubClass>());
      });

      test('then its name is correct.', () {
        expect(endpoint.name, 'concreteSubClass');
      });

      test('then it is initialized correctly on the client.', () {
        expect(client.concreteSubClass, isA<EndpointConcreteSubClass>());
      });
    },
  );

  group(
    'Given an instance of an endpoint class that extends a class annotated as @doNotGenerate',
    () {
      var endpoint = EndpointIndependent(client);

      test('then it is subclass of EndpointRef directly.', () {
        expect(endpoint, isNot(isA<EndpointConcreteSubClass>()));
        expect(endpoint, isNot(isA<EndpointAbstractSubClass>()));
        expect(endpoint, isNot(isA<EndpointConcreteBase>()));
        expect(endpoint, isNot(isA<EndpointAbstractBase>()));
        expect(endpoint, isA<EndpointRef>());
      });

      test('then its name is correct.', () {
        expect(endpoint.name, 'independent');
      });

      test('then it is initialized correctly on the client.', () {
        expect(client.independent, isA<EndpointIndependent>());
      });

      test('then it has methods from all previous endpoints.', () {
        expect(endpoint.virtualMethod, isA<Function>());
        expect(endpoint.abstractBaseMethod, isA<Function>());
        expect(endpoint.abstractBaseStreamMethod, isA<Function>());
        expect(endpoint.concreteMethod, isA<Function>());
        expect(endpoint.subClassVirtualMethod, isA<Function>());
      });
    },
  );

  test(
    'Given an abstract endpoint class that extends an abstract endpoint class from a module '
    'then it is subclass of the generated module abstract class.',
    () {
      expect(
        isSubClass<EndpointAbstractModuleBase, m.EndpointAbstractBase>(),
        isTrue,
      );
    },
  );

  group(
    'Given an instance of a concrete module endpoint that extends an abstract endpoint from the same module',
    () {
      var endpoint = client.modules.module.concreteBase;

      test('then it is subclass of the generated module abstract class.', () {
        expect(endpoint, isA<m.EndpointAbstractBase>());
      });

      test('then its name is correct.', () {
        expect(endpoint.name, 'serverpod_test_module.concreteBase');
      });
    },
  );

  group(
    'Given an instance of a concrete endpoint that extends an abstract endpoint from a module',
    () {
      var endpoint = EndpointConcreteFromModuleAbstractBase(client);

      test('then it is subclass of the generated module abstract class.', () {
        expect(endpoint, isA<m.EndpointAbstractBase>());
      });

      test('then its name is correct.', () {
        expect(endpoint.name, 'concreteFromModuleAbstractBase');
      });

      test('then it is initialized correctly on the client.', () {
        expect(
          client.concreteFromModuleAbstractBase,
          isA<EndpointConcreteFromModuleAbstractBase>(),
        );
      });
    },
  );

  group(
    'Given an instance of a concrete endpoint that extends a concrete endpoint from a module',
    () {
      var endpoint = EndpointConcreteModuleBase(client);

      test('then it is subclass of the generated module concrete class.', () {
        expect(endpoint, isA<m.EndpointConcreteBase>());
      });

      test('then its name is correct.', () {
        expect(endpoint.name, 'concreteModuleBase');
      });

      test('then it is initialized correctly on the client.', () {
        expect(client.concreteModuleBase, isA<EndpointConcreteModuleBase>());
      });
    },
  );

  test(
    'Given an abstract endpoint class that extends a concrete endpoint class from a module'
    'then it is subclass of the generated module concrete class.',
    () {
      expect(
        isSubClass<EndpointAbstractModuleSubClass, m.EndpointConcreteBase>(),
        isTrue,
      );
    },
  );
}

bool isSubClass<S, T>() => <S>[] is List<T>;
