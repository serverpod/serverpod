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
        Object k => _locateByKey<T>(k),
        // If no key is provided, locate the service by type.
        null => _locateByType<T>(),
      };

  T _locateByKey<T>(Object key) {
    if (!_services.containsKey(key)) {
      throw ServiceKeyNotFoundException(T, key);
    }

    var result = _services[key];

    if (result is! T) {
      throw InvalidServiceTypeException(T, result.runtimeType);
    }

    return result;
  }

  T _locateByType<T>() {
    if (!_services.containsKey(T)) {
      throw ServiceNotFoundException(T);
    }

    var result = _services[T];

    if (result is! T) {
      throw InvalidServiceTypeException(T, result.runtimeType);
    }

    return result;
  }

  /// Register a service.
  ///
  /// If a key is provided, it registers the service by that key.
  /// If no key is provided, it registers the service by its type.
  void register<T>(T service, {Object? key}) {
    if (key != null) {
      _registerKey<T>(key, service);
    } else {
      _registerType<T>(service);
    }
  }

  /// Register a service by its type.
  /// Throws [ServiceAlreadyRegisteredException] if a service of the same type is already registered.
  void _registerType<T>(T service) {
    if (_services.containsKey(T)) {
      throw ServiceAlreadyRegisteredException(T);
    }

    _services[T] = service;
  }

  /// Register a service by a unique key.
  /// Throws [ServiceKeyAlreadyRegisteredException] if a service with the same key is already registered.
  void _registerKey<T>(Object key, T service) {
    if (_services.containsKey(key)) {
      throw ServiceKeyAlreadyRegisteredException(key, T);
    }

    try {
      _registerType(service);
    } catch (e) {
      // If the service is already registered by type, we can ignore this error
      // since we are registering it by key as well.
      if (e is ServiceAlreadyRegisteredException) {
        // Do nothing, we can safely ignore this.
      } else {
        rethrow; // Rethrow any other exceptions.
      }
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
