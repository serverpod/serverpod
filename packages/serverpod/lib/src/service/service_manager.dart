/// Holder for configured service instances
///
/// Callers can register and locate services
class ServiceHolder {
  final Map<Type, dynamic> _registered = {};
  ServiceHolder._();

  /// Register the specified service
  /// The caller is allowed to swap out service, so no checks
  /// are performed.  Null will result in an exception
  void register(dynamic service) {
    _registered[service.runtimeType] = service;
  }

  /// Get the service of the specified type
  ///
  /// Null is returned if no service of the specified type is configured
  T? locate<T>() {
    return _registered[T];
  }
}

/// Class that knows how to locate services of a specific type
///
/// This class alows for the retrieval of configured services
/// But provides no ability to configure services itself.
class ServiceLocator {
  final ServiceHolder _services;

  /// construct a new [ServiceLocator] for the [ServiceHolder]
  ///
  /// Having locator and holder in separate classes
  /// means that you can expose services while simultaneously
  /// controlling where services can be configured
  ServiceLocator(this._services);

  /// Get the service of the specified type from the [ServieHolder]
  ///
  /// Null is returned if no service of the specified type is configured
  T? locate<T>() => _services.locate<T>();
}

/// Class responsible for tracking all configured service holder instances
class ServiceManager {
  static const String defaultId = 'serverpod';

  static final Map<String, ServiceHolder> _configured = {};

  /// Register a service group
  ///
  /// Registration can only be performed one time.  An exception will
  /// be thrown on successive attempts to register the same name.
  /// The caller needs to hold onto the [ServiceHolder] for as long as
  /// managing the configured services is required
  static ServiceHolder register(String name) {
    if (_configured.containsKey(name)) {
      throw Exception('Services for $name already registerd');
    }

    ServiceHolder holder = ServiceHolder._();
    _configured[name] = holder;

    return holder;
  }

  /// Obtain a service locator for the named service group
  ///
  /// An exception will be thrown if the named [ServiceHolder] does not exist.
  static ServiceLocator request(String name) {
    ServiceHolder? holder = _configured[name];
    if (holder == null) {
      throw Exception('Services for $name not registered');
    }

    return ServiceLocator(holder);
  }

  ServiceManager._();
}
