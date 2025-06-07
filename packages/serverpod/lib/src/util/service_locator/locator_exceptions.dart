/// Exception thrown when lookup by type fails
class ServiceNotFoundException implements Exception {
  /// The [Type] the lookup failed for
  final Type type;

  /// Create a new instance for a failed [Type] lookup
  ServiceNotFoundException(this.type);

  @override
  String toString() =>
      'ServiceNotFoundException: No service found for type $type';
}

/// Exception thrown when lookup by key fails
class ServiceKeyNotFoundException implements Exception {
  /// The [Type] the lookup failed for
  final Type type;

  /// The key the lookup failed for
  final String key;

  /// Create a new instance for a failed lookup by key
  ServiceKeyNotFoundException(this.type, this.key);

  @override
  String toString() =>
      'ServiceKeyNotFoundException: No service found for key $key of type $type';
}

/// Exception thrown when trying to register a service that is already registered
class ServiceAlreadyRegisteredException implements Exception {
  /// The type of the service that is already registered
  final Type type;

  /// Create a new instance for a service that is already registered
  ServiceAlreadyRegisteredException(this.type);

  @override
  String toString() =>
      'ServiceAlreadyRegisteredException: A service of type $type is already registered';
}

/// Exception thrown when trying to register a service with a key that is already registered
class ServiceKeyAlreadyRegisteredException implements Exception {
  /// The key that is already registered
  final String key;

  /// The type of the service that is already registered
  final Type type;

  /// Create a new instance for a service key that is already registered
  ServiceKeyAlreadyRegisteredException(this.key, this.type);

  @override
  String toString() =>
      'ServiceKeyAlreadyRegisteredException: A service with key $key of type $type is already registered';
}
