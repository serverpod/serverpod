import 'locator_exceptions.dart';

/// A service locator interface that allows for locating services by type or key.
// This interface is used to decouple service registration and retrieval.
abstract interface class ServiceLocator {
  /// Locates a service by its type.
  /// Throws [ServiceNotFoundException] if the service is not found.
  /// @param T The type of the service to locate.
  /// @return The service of type [T] if found.
  T locate<T>([Object? key]);
}

/// A concrete implementation of [ServiceLocator] that holds services in memory.
/// It allows for registering services by type or by a unique key.
class ServiceHolder implements ServiceLocator {
  final Map<Object, dynamic> _services = {};

  /// Creates a new [ServiceHolder] with an optional parent service locator.
  ServiceHolder();

  @override
  T locate<T>([Object? key]) => switch (key) {
        // If a key is provided, locate the service by that key.
        Object k => _locate<T>(k),
        // If no key is provided, locate the service by type.
        null => _locate<T>(T),
      };

  T _locate<T>(Object key) {
    if (!_services.containsKey(key)) {
      throw ServiceNotFoundException(key);
    }

    var result = _services[key];

    if (result is! T) {
      throw InvalidServiceTypeException(T, result.runtimeType);
    }

    return result;
  }

  /// Register a service.
  ///
  /// If a key is provided, it registers the service by that key.
  /// If no key is provided, it registers the service by its type.
  ///
  /// Throws [ServiceAlreadyRegisteredException] if a service is already
  /// registered for the given key or type.
  void register<T>(T service, {Object? key}) => switch (key) {
        Object k => _register<T>(k, service),
        null => _register<T>(T, service),
      };

  void _register<T>(Object key, T service) {
    if (_services.containsKey(key)) {
      var existingService = _services[key];
      throw ServiceAlreadyRegisteredException(key, existingService);
    }

    _services[key] = service;
  }
}

/// Provide a view of the service locator.
/// This is useful when you want to expose the service locator without allowing
/// modification of its contents.
extension type ServiceLocatorView(ServiceLocator serviceLocator) {
  /// Locates a service by its type or key.
  /// Throws [ServiceNotFoundException] if the service is not found.
  T locate<T>([Object? key]) => serviceLocator.locate<T>(key);
}
