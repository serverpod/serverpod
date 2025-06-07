import 'package:test/test.dart';
import 'package:serverpod/src/util/service_locator/service_locator.dart';
import 'package:serverpod/src/util/service_locator/locator_exceptions.dart';

class TestService {}

class AnotherService {}

void main() {
  group('ServiceHolder', () {
    late ServiceHolder locator;

    setUp(() {
      locator = ServiceHolder();
    });

    test('registers and locates service by type', () {
      final service = TestService();
      locator.registerType<TestService>(service);
      expect(locator.locate<TestService>(), same(service));
    });

    test('throws when locating unregistered type', () {
      expect(() => locator.locate<TestService>(),
          throwsA(isA<ServiceNotFoundException>()));
    });

    test('throws when registering type twice', () {
      locator.registerType<TestService>(TestService());
      expect(() => locator.registerType<TestService>(TestService()),
          throwsA(isA<ServiceAlreadyRegisteredException>()));
    });

    test('registers and locates service by key', () {
      final service = TestService();
      locator.registerKey<TestService>('myKey', service);
      expect(locator.locate<TestService>(key: 'myKey'), same(service));
    });

    test('throws when locating unregistered key', () {
      expect(() => locator.locate<TestService>(key: 'unknown'),
          throwsA(isA<ServiceKeyNotFoundException>()));
    });

    test('throws when registering key twice', () {
      locator.registerKey<TestService>('myKey', TestService());
      expect(() => locator.registerKey<TestService>('myKey', TestService()),
          throwsA(isA<ServiceKeyAlreadyRegisteredException>()));
    });

    test('throws when locating key with wrong type', () {
      locator.registerKey<TestService>('myKey', TestService());
      expect(() => locator.locate<AnotherService>(key: 'myKey'),
          throwsA(isA<ServiceNotFoundException>()));
    });

    test('walks up parent chain for type', () {
      final parent = ServiceHolder();
      final child = ServiceHolder(parent: parent);
      final service = TestService();
      parent.registerType<TestService>(service);
      expect(child.locate<TestService>(), same(service));
    });

    test('walks up parent chain for key', () {
      final parent = ServiceHolder();
      final child = ServiceHolder(parent: parent);
      final service = TestService();
      parent.registerKey<TestService>('myKey', service);
      expect(child.locate<TestService>(key: 'myKey'), same(service));
    });
  });

  group('WrappingServiceLocator', () {
    test('delegates to underlying locator', () {
      final holder = ServiceHolder();
      final wrapper = WrappingServiceLocator(holder);
      final service = TestService();
      holder.registerType<TestService>(service);
      expect(wrapper.locate<TestService>(), same(service));
    });
  });

  group('_StubServiceLocator', () {
    const stub = StubServiceLocator();
    test('always throws for type', () {
      expect(() => stub.locate<TestService>(),
          throwsA(isA<ServiceNotFoundException>()));
    });
    test('always throws for key', () {
      expect(() => stub.locate<TestService>(key: 'key'),
          throwsA(isA<ServiceKeyNotFoundException>()));
    });
  });
}
