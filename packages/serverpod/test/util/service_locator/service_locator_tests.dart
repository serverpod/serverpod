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
      expect(locator.locateType<TestService>(), same(service));
    });

    test('throws when locating unregistered type', () {
      expect(() => locator.locateType<TestService>(), throwsA(isA<ServiceNotFoundException>()));
    });

    test('throws when registering type twice', () {
      locator.registerType<TestService>(TestService());
      expect(() => locator.registerType<TestService>(TestService()), throwsA(isA<ServiceAlreadyRegisteredException>()));
    });

    test('registers and locates service by key', () {
      final service = TestService();
      locator.registerKey<TestService>('myKey', service);
      expect(locator.locateKey<TestService>('myKey'), same(service));
    });

    test('throws when locating unregistered key', () {
      expect(() => locator.locateKey<TestService>('unknown'), throwsA(isA<ServiceKeyNotFoundException>()));
    });

    test('throws when registering key twice', () {
      locator.registerKey<TestService>('myKey', TestService());
      expect(() => locator.registerKey<TestService>('myKey', TestService()), throwsA(isA<ServiceKeyAlreadyRegisteredException>()));
    });

    test('throws when locating key with wrong type', () {
      locator.registerKey<TestService>('myKey', TestService());
      expect(() => locator.locateKey<AnotherService>('myKey'), throwsA(isA<ServiceNotFoundException>()));
    });

    test('walks up parent chain for type', () {
      final parent = ServiceHolder();
      final child = ServiceHolder(parent: parent);
      final service = TestService();
      parent.registerType<TestService>(service);
      expect(child.locateType<TestService>(), same(service));
    });

    test('walks up parent chain for key', () {
      final parent = ServiceHolder();
      final child = ServiceHolder(parent: parent);
      final service = TestService();
      parent.registerKey<TestService>('myKey', service);
      expect(child.locateKey<TestService>('myKey'), same(service));
    });
  });

  group('WrappingServiceLocator', () {
    test('delegates to underlying locator', () {
      final holder = ServiceHolder();
      final wrapper = WrappingServiceLocator(holder);
      final service = TestService();
      holder.registerType<TestService>(service);
      expect(wrapper.locateType<TestService>(), same(service));
    });
  });

  group('_StubServiceLocator', () {
    const stub = StubServiceLocator();
    test('always throws for type', () {
      expect(() => stub.locateType<TestService>(), throwsA(isA<ServiceNotFoundException>()));
    });
    test('always throws for key', () {
      expect(() => stub.locateKey<TestService>('key'), throwsA(isA<ServiceKeyNotFoundException>()));
    });
  });
}
