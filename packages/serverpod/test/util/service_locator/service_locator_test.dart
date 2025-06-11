import 'package:test/test.dart';
import 'package:serverpod/src/util/service_locator/service_locator.dart';
import 'package:serverpod/src/util/service_locator/locator_exceptions.dart';

class TestService {}

class AnotherService {}

void main() {
  group('Given empty service locator ', () {
    late ServiceLocator locator;

    setUp(() {
      locator = ServiceLocator();
    });

    test(
        'when registering service by type '
        'then service can be located up by type', () {
      final service = TestService();
      locator.register<TestService>(service);

      expect(locator.locate<TestService>(), same(service));
    });

    test(
        'when registering service by key '
        'then service can be located by key', () {
      const serviceKey = #key;
      final service = TestService();
      locator.register<TestService>(service, key: serviceKey);

      expect(locator.locate<TestService>(serviceKey), same(service));
    });

    test(
        'when registering by same type twice '
        'then throws ServiceAlreadyRegisteredException with matching key and type',
        () {
      var service = TestService();
      locator.register<TestService>(service);

      expect(
        () => locator.register<TestService>(TestService()),
        throwsA(isA<ServiceAlreadyRegisteredException>()
            .having((e) => e.key, 'key', TestService)
            .having((e) => e.type, 'type', service)),
      );
    });

    test(
        'when registering different services with the same key '
        'then throws ServiceAlreadyRegisteredException with matching key and type of the first registered service',
        () {
      const serviceKey = #key;
      var service = TestService();
      locator.register<TestService>(service, key: serviceKey);

      expect(
        () =>
            locator.register<AnotherService>(AnotherService(), key: serviceKey),
        throwsA(isA<ServiceAlreadyRegisteredException>()
            .having((e) => e.key, 'key', serviceKey)
            .having((e) => e.type, 'type', service)),
      );
    });

    test(
        'when locating unregistered service by type '
        'then throws ServiceNotFoundException with type as key', () {
      expect(
          () => locator.locate<TestService>(),
          throwsA(isA<ServiceNotFoundException>().having(
            (e) => e.key,
            'key',
            TestService,
          )));
    });

    test(
        'when locating unregistered service by key '
        'then throws ServiceNotFoundException with provided key as key', () {
      const serviceKey = #key;
      expect(
          () => locator.locate<TestService>(serviceKey),
          throwsA(isA<ServiceNotFoundException>()
              .having((e) => e.key, 'key', serviceKey)));
    });

    test(
        'when removing unregistered service by type '
        'then throws ServiceNotFoundException', () {
      expect(() => locator.remove<TestService>(),
          throwsA(isA<ServiceNotFoundException>()));
    });
  });

  test(
      'Given service locator with service registered by type'
      'when removing service by type '
      'then service is removed', () {
    var locator = ServiceLocator();
    locator.register<TestService>(TestService());
    locator.remove<TestService>();

    expect(() => locator.locate<TestService>(),
        throwsA(isA<ServiceNotFoundException>()));
  });

  test(
      'Given service locator with service registered by key'
      'when removing service by key '
      'then service is removed', () {
    var locator = ServiceLocator();
    var serviceKey = #key;
    locator.register<TestService>(TestService(), key: serviceKey);
    locator.remove<TestService>(serviceKey);

    expect(() => locator.locate<TestService>(serviceKey),
        throwsA(isA<ServiceNotFoundException>()));
  });

  test(
      'Given service locator with one service registered by key from the type of second service '
      'when locating by type of second service '
      'then throws InvalidServiceTypeException', () {
    var locator = ServiceLocator();
    locator.register<TestService>(TestService(), key: AnotherService);

    expect(
      () => locator.locate<AnotherService>(),
      throwsA(isA<InvalidServiceTypeException>()
          .having((e) => e.expectedType, 'expectedType', AnotherService)
          .having((e) => e.receivedType, 'receivedType', TestService)),
    );
  });

  test(
      'Given service locator with service registered by key '
      'when locating with same key but different type '
      'then throws InvalidServiceTypeException', () {
    var locator = ServiceLocator();
    var serviceKey = #key;
    locator.register<TestService>(TestService(), key: serviceKey);

    expect(
      () => locator.locate<AnotherService>(serviceKey),
      throwsA(isA<InvalidServiceTypeException>()
          .having((e) => e.expectedType, 'expectedType', AnotherService)
          .having((e) => e.receivedType, 'receivedType', TestService)),
    );
  });

  test(
      'Given service locator view of service locator with registered service '
      'when accessing service '
      'then service is the same as service locator', () {
    final locator = ServiceLocator();
    final serviceLocatorView = ServiceLocatorView(locator);
    final service = TestService();
    locator.register<TestService>(service);

    var locatedService = serviceLocatorView.locate<TestService>();

    expect(locatedService, same(service));
  });
}
