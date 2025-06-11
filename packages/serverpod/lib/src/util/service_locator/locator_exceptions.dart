/// Base exception for all service locator related exceptions.
abstract final class ServiceLocatorException implements Exception {}

/// Exception thrown when a lookup fails due to an invalid type
final class InvalidServiceTypeException extends ServiceLocatorException {
  /// The type that was expected
  final Type expectedType;

  /// The type that was received
  final Type receivedType;

  /// Create a new instance for an invalid service type exception
  InvalidServiceTypeException(this.expectedType, this.receivedType);

  @override
  String toString() =>
      'InvalidServiceTypeException: Expected type $expectedType but received $receivedType';
}

/// Exception thrown when lookup fails
final class ServiceNotFoundException extends ServiceLocatorException {
  /// The key the lookup failed for
  final Object key;

  /// Create a new instance for a failed lookup by key
  ServiceNotFoundException(this.key);

  @override
  String toString() =>
      'ServiceKeyNotFoundException: No service found for key $key';
}

/// Exception thrown when trying to register that is already registered
final class ServiceAlreadyRegisteredException extends ServiceLocatorException {
  /// The key that is already registered
  final Object key;

  /// The type of the service that is already registered
  final Object type;

  /// Create a new instance for a service key that is already registered
  ServiceAlreadyRegisteredException(this.key, this.type);

  @override
  String toString() =>
      'ServiceKeyAlreadyRegisteredException: A service with key $key of type $type is already registered';
}
