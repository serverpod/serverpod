/// The default passwords used by the server.
enum ServerpodPassword {
  /// The password for the database.
  databasePassword,

  /// The secret used by insights to authenticate the client.
  serviceSecret,

  /// The password for the redis broker.
  redisPassword,
}

/// The key and variable name for the password.
extension ServerpodPasswordExt on ServerpodPassword {
  /// The key used in the password configuration file.
  String get key {
    return switch (this) {
      (ServerpodPassword.databasePassword) => 'database',
      (ServerpodPassword.serviceSecret) => 'serviceSecret',
      (ServerpodPassword.redisPassword) => 'redis',
    };
  }

  /// The environment variable name for the password.
  String get variable {
    return switch (this) {
      (ServerpodPassword.databasePassword) => 'SERVERPOD_DATABASE_PASSWORD',
      (ServerpodPassword.serviceSecret) => 'SERVERPOD_SERVICE_SECRET',
      (ServerpodPassword.redisPassword) => 'SERVERPOD_REDIS_PASSWORD',
    };
  }
}
