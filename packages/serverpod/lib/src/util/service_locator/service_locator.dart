import 'locator_exceptions.dart';

/// A service locator that allows registering and locating services
/// by type or by a specific key.
///
/// This class is useful for dependency injection and service management
/// in applications, allowing for flexible service retrieval without
/// tight coupling between components.
class ServiceLocator {
  final Map<Object, dynamic> _services = {};

  /// Creates a new [ServiceLocator].
  ServiceLocator();

  /// Locates a service by its type or an optional key.
  ///
  /// Throws [ServiceNotFoundException] if the service is not found,
  /// or [InvalidServiceTypeException] if the found service is not of the
  /// expected type.
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

  /// Remove a service by its type or an optional key.
  ///
  /// Throws [ServiceNotFoundException] if the service is not found.
  void remove<T>([Object? key]) {
    key ??= T;

    if (!_services.containsKey(key)) {
      throw ServiceNotFoundException(key);
    }
    _services.remove(key);
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
