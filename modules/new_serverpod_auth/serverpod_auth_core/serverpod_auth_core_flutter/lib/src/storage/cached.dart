import '/src/storage/base.dart';

/// Implements the cache layer for a [ClientAuthInfoStorage] implementation. The
/// [get] methods return is cached, so the operation can be performed with no
/// performance concerns.
class CachedClientAuthInfoStorage implements ClientAuthInfoStorage {
  /// The delegate to perform the actual (un-cached) storage operations.
  final ClientAuthInfoStorage _delegate;

  /// Creates a new [CachedClientAuthInfoStorage].
  CachedClientAuthInfoStorage({required ClientAuthInfoStorage delegate})
      : _delegate = delegate;

  /// Control whether the value can be recovered from the internal cache on
  /// [get] method. Will be false only before the first method call.
  var _cached = false;

  AuthSuccess? _cachedData;

  @override
  Future<void> set(AuthSuccess? data) async {
    await _delegate.set(data);
    _cachedData = data;
    _cached = true;
  }

  @override
  Future<AuthSuccess?> get() async {
    if (_cached) return _cachedData;
    final data = await _delegate.get();
    _cachedData = data;
    _cached = true;
    return _cachedData;
  }
}
