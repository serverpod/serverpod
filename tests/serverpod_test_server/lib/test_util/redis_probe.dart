import 'dart:io';

bool? _reachable;

/// Whether the Redis the integration configs point is reachable.
/// Probed once per isolate.
Future<bool> isRedisAvailable() async {
  if (_reachable != null) return _reachable!;
  try {
    final socket = await Socket.connect(
      'redis',
      6379,
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
    : 'Redis is not reachable (host `redis`, port 6379). CI hosts one; '
          'locally run Redis and map `redis` in /etc/hosts to include this.';
