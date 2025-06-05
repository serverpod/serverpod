class ServiceLocatorException implements Exception {
  final String message;

  ServiceLocatorException(this.message);

  @override
  String toString() => 'ServiceLocatorException: $message';
}

class ServiceNotFoundException implements Exception {
  final Type type;

  ServiceNotFoundException(this.type);

  @override
  String toString() => 'ServiceNotFoundException: No service found for type $type';
}

class ServiceKeyNotFoundException implements Exception {
  final String key;
  final Type type;

  ServiceKeyNotFoundException(this.key, this.type);

  @override
  String toString() => 'ServiceKeyNotFoundException: No service found for key $key of type $type';
}

class ServiceAlreadyRegisteredException implements Exception {
  final Type type;

  ServiceAlreadyRegisteredException(this.type);

  @override
  String toString() => 'ServiceAlreadyRegisteredException: A service of type $type is already registered';
}

class ServiceKeyAlreadyRegisteredException implements Exception {
  final String key;
  final Type type;

  ServiceKeyAlreadyRegisteredException(this.key, this.type);

  @override
  String toString() => 'ServiceKeyAlreadyRegisteredException: A service with key $key of type $type is already registered';
}

