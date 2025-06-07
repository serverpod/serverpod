import 'locator_exceptions.dart';

/// A service locator interface that allows for locating services by type or key.
// This interface is used to decouple service registration and retrieval.
abstract interface class ServiceLocator {
  /// Locates a service by its type.
  /// Throws [ServiceNotFoundException] if the service is not found.
  /// @param T The type of the service to locate.
  /// @return The service of type [T] if found.
  T locate<T>({String? key});
}

/// A concrete implementation of [ServiceLocator] that holds services in memory.
/// It allows for registering services by type or by a unique key.
class ServiceHolder implements ServiceLocator {
  final ServiceLocator _parent;
  final Map<Type, dynamic> _services = {};
  final Map<String, dynamic> _keyedServices = {};

  /// Creates a new [ServiceHolder] with an optional parent service locator.
  ServiceHolder({ServiceLocator parent = const StubServiceLocator()})
      : _parent = parent;

  /// Walk up the service locator hierarchy to find a service by type.
  @override
  T locate<T>({String? key}) {
    if (key != null) {
      return _locateKey<T>(key);
    }
    // If no key is provided, locate the service by type.
    T result = _services.containsKey(T)
        ? _services[T] as T
        : _parent.locate<T>(key: key);
    return result;
  }

  /// Walk up the service locator hierarchy to find a service by key.
  /// Throws [ServiceKeyNotFoundException] if the key is not found.
  /// Throws [ServiceNotFoundException] if the type does not match the found service.
  T _locateKey<T>(String key) {
    var result = _keyedServices.containsKey(key)
        ? _keyedServices[key]
        : _parent.locate<T>(key: key);
    if (result.runtimeType != T) {
      throw ServiceNotFoundException(T);
    }

    return result;
  }

  /// Register a service by its type.
  /// Throws [ServiceAlreadyRegisteredException] if a service of the same type is already registered.
  void registerType<T>(T service) {
    if (_services.containsKey(T)) {
      throw ServiceAlreadyRegisteredException(T);
    }
    _services[T] = service;
  }

  /// Register a service by a unique key.
  /// Throws [ServiceKeyAlreadyRegisteredException] if a service with the same key is already registered.
  void registerKey<T>(String key, T service) {
    if (_keyedServices.containsKey(key)) {
      throw ServiceKeyAlreadyRegisteredException(key, T);
    }

    try {
      registerType(service);
    } catch (e) {
      // If the service is already registered by type, we can ignore this error
      // since we are registering it by key as well.
      if (e is ServiceAlreadyRegisteredException) {
        // Do nothing, we can safely ignore this.
      } else {
        rethrow; // Rethrow any other exceptions.
      }
    }

    _keyedServices[key] = service;
  }
}

/// Provide an interface only view of the service locator.
/// This is useful when you want to expose the service locator without allowing
/// modification of its contents.
/// It wraps an existing [ServiceLocator] instance and provides the same methods.
class WrappingServiceLocator implements ServiceLocator {
  final ServiceLocator _serviceLocator;

  /// Creates a new [WrappingServiceLocator] that wraps the provided [ServiceLocator].
  WrappingServiceLocator(this._serviceLocator);

  @override
  T locate<T>({String? key}) => _serviceLocator.locate<T>(key: key);
}

/// Always fail implementation of [ServiceLocator].
/// Rather than doing a bunch of if checks to see if the parent service locator is null,
/// ServiceHolder will always have a parent service locator.
/// This stub implementation will always throw an exception when trying to locate a service.
/// It might not be the most efficient implementation, but it is simple and effective,
/// and should be good enough for most use cases.
class StubServiceLocator implements ServiceLocator {
  /// Creates a new [StubServiceLocator] that always throws exceptions.
  const StubServiceLocator();

  @override
  T locate<T>({String? key}) {
    throw key == null
        ? ServiceNotFoundException(T)
        : ServiceKeyNotFoundException(T, key);
  }
}
