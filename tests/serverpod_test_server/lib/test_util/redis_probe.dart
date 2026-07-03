import 'dart:io';

import 'package:serverpod_shared/serverpod_shared.dart' show RedisConfig;

const redisTestHost = 'redis';
const redisTestPort = 6379;

/// Redis config for suites that test redis-backed behavior.
RedisConfig redisTestConfig() => RedisConfig(
  enabled: true,
  host: redisTestHost,
  port: redisTestPort,
  // Matches config/passwords.yaml and CI's `redis-server --requirepass`.
  password: 'password',
);

bool? _reachable;

/// Whether the Redis the integration configs point is reachable.
Future<bool> isRedisAvailable() async {
  if (_reachable != null) return _reachable!;
  try {
    final socket = await Socket.connect(
      redisTestHost,
      redisTestPort,
      timeout: const Duration(seconds: 2),
    );
    socket.destroy();
    _reachable = true;
  } catch (_) {
    _reachable = false;
  }
  return _reachable!;
}

/// Skip reason for redis-dependent tests, or null when Redis is reachable.
Future<String?> redisSkipReason() async => await isRedisAvailable()
    ? null
    : 'Redis is not reachable (host `$redisTestHost`, port $redisTestPort). '
          'Run Redis and map `$redisTestHost` in /etc/hosts to include this.';
