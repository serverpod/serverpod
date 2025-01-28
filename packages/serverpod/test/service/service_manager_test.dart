import 'package:serverpod/src/service/service_manager.dart';
import 'package:test/test.dart';

class DummyService {}

/// Since [ServiceManager] relies on static variables, all tests using register should use a unique name
void main() {
  group('Service Manager Functions', () {
    test('Locating configured service returns the configured value', () {
      ServiceHolder holder = ServiceHolder();
      DummyService service = DummyService();
      holder.register(service);
      expect(holder.locate<DummyService>(), service);
    });

    test('Locating missing service returns null', () {
      ServiceHolder holder = ServiceHolder();
      expect(holder.locate<DummyService>(), null);
    });

    test('Registering duplicate names throws exception', () {
      ServiceHolder holder = ServiceHolder();
      holder.register('data', name: 'text');
      expect(
          () => holder.register('other data', name: 'text'), throwsException);
    });

    test(
        'Registering the same type twice, as anonymous value, throws exception',
        () {
      ServiceHolder holder = ServiceHolder();
      holder.register('anonymous1');
      expect(() => holder.register('anonymous2'), throwsException);
    });

    test('Registering null with a null name throws exception', () {
      ServiceHolder holder = ServiceHolder();
      expect(() => holder.register(null, name: null), throwsException);
    });

    test('Replacing a value causes the new value to be located', () {
      ServiceHolder holder = ServiceHolder();
      holder.register('anonymous');
      expect(holder.locate<String>(), 'anonymous');

      holder.replace('anonymous-again');
      expect(holder.locate<String>(), 'anonymous-again');
    });

    test('Locating downstream will find upstream components', () {
      ServiceHolder holder = ServiceHolder();
      ServiceHolder downstream = ServiceHolder(upstream: holder);

      holder.register('anonymous');
      expect(downstream.locate<String>(), 'anonymous');
    });

    test('Overriding a value value downstream returns the overriden value', () {
      ServiceHolder holder = ServiceHolder();
      DummyService service1 = DummyService();
      holder.register(service1);

      DummyService service2 = DummyService();
      ServiceHolder downstream = ServiceHolder(upstream: holder);
      downstream.register(service2);

      expect(downstream.locate<DummyService>(), service2);

      DummyService service3 = DummyService();
      holder.replace(service3);
      expect(holder.locate<DummyService>(), service3);
      expect(downstream.locate<DummyService>(), service2);
    });
  });
}
