/// Interface for Classes that knows how to locate services of a specific type
///
/// This class alows for the retrieval of configured services
/// But provides no ability to configure services itself.
abstract interface class ServiceLocator {
  /// Locate a component of the specified type
  /// Multiple components of the same type can be differentiated with
  /// a name
  T? locate<T>({String? name});
}

/// Holder for configured component instances
///
/// Callers can register and locate services
class ServiceHolder implements ServiceLocator {
  final Map<String, dynamic> _named = {};

  final ServiceLocator? _upstream;

  /// Create a new [ServiceHolder] instance
  ServiceHolder({ServiceLocator? upstream}) : _upstream = upstream;

  /// generate a name based on a [Type]
  String anonymousName(Type type) {
    return 'anonymous($type)';
  }

  /// Determine if we use a supplied name or a generated name
  ///
  /// generated name will be 'anonymous(Type)'
  String keyName(component, String? name) {
    if (component == null && name == null) {
      throw Exception('Either component or name must be non-null');
    }

    return name ?? anonymousName(component.runtimeType);
  }

  /// Register the specified component
  ///
  /// Registering the same name twice results in an exception.
  ///
  /// Registring multiple unnamed components of the same type
  /// results in an exception
  ///
  /// Specifying null for both the [component] and the [name]
  /// will result in an exception
  void register(dynamic component, {String? name}) {
    // throws an exception if both parameters are null
    String key = keyName(component, name);

    // don't allow changing of registered components
    // as this leads to hard to diagnose bugs
    if (_named.containsKey(key)) {
      throw Exception('The name $key is already registered');
    }

    _named[key] = component;
  }

  /// Replace a configured component with another
  ///
  /// If the component is not registered, an exception is thrown
  void replace(dynamic component, {String? name}) {
    // throws an exception if both parameters are null
    String key = keyName(component, name);
    if (_named.containsKey(key)) {
      _named[key] = component;
    } else {
      throw Exception('Component with name $key is not registered');
    }
  }

  /// Get the component of the specified type
  ///
  /// Null is returned if no component of the specified type is configured
  @override
  T? locate<T>({String? name}) {
    // determine the name to use for lookup
    String key = name ?? anonymousName(T);

    // check our map of registered servies for a match
    // if no match is found, and _upstream is not null
    // then attempt to locate the component upstream
    var result = _named[key] ?? _upstream?.locate<T>();

    // this will throw an exception if the result is non-null
    // and the types don't match.  This is desired behavior,
    // but we might want to have an explicit check and exception
    // for clarity
    return result;
  }
}

/// Implementation of [ServiceLocator] that wraps a ServiceHolder
class WrappingServiceLocator implements ServiceLocator {
  final ServiceHolder _holder;

  /// Create a new instance that wraps a [ServiceHolder]
  WrappingServiceLocator(this._holder);

  @override
  T? locate<T>({String? name}) => _holder.locate<T>();
}
