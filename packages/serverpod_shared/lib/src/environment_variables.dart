/// The configuration sections for the serverpod configuration file.
class ServerpodConfigMap {
  /// The api server configuration.
  static const String apiServer = 'apiServer';

  /// The insights server configuration.
  static const String insightsServer = 'insightsServer';

  /// The web server configuration.
  static const String webServer = 'webServer';

  /// The database configuration.
  static const String database = 'database';

  /// The redis configuration.
  static const String redis = 'redis';
}

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
