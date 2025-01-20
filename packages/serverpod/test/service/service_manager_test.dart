import 'package:serverpod/src/service/service_manager.dart';
import 'package:test/test.dart';

class DummyService {}

/// Since [ServiceManager] relies on static variables, all tests using register should use a unique name
void main() {
  group('Service Manager Functions', () {
    test('Registering a service holder once succeeds', () {
      expect(ServiceManager.register('once'), const TypeMatcher<ServiceHolder>());
    });

    test('Registering a service holder twice throws an exception', () {
      const String serviceId = 'twice';
      ServiceManager.register(serviceId);
      expect(() => ServiceManager.register(serviceId), throwsA(isA<Exception>()));
    });

    test('Requesting registered service holder succeeds', () {
      const String serviceId = 'registered';
      ServiceManager.register(serviceId);
      expect(ServiceManager.request(serviceId), const TypeMatcher<ServiceLocator>());
    });

    test('Requesting an unregistered service holder throws an exception', () {
      expect(() => ServiceManager.request('nothing'), throwsA(isA<Exception>()));
    });

    test('Locating configured service returns the configured value', () {
      const String serviceId = 'present';
      ServiceHolder holder = ServiceManager.register(serviceId);
      DummyService service = DummyService();
      holder.register(service);
      ServiceLocator locator = ServiceManager.request(serviceId);
      expect(locator.locate<DummyService>(), service);
    });

    test('Locating missing service returns null', () {
      const String serviceId = 'missing';
      ServiceHolder holder = ServiceManager.register(serviceId);
      ServiceLocator locator = ServiceManager.request(serviceId);
      expect(locator.locate<DummyService>(), null);
    });
  });
}
