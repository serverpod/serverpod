import 'package:serverpod/serverpod.dart';

class MyCustomCache extends Cache {
  MyCustomCache(SerializationManager serializationManager)
    : super(10000, serializationManager);

  @override
  Future<void> clear() async {}

  @override
  Future<bool> containsKey(String key) async => false;

  @override
  Future<T?> get<T extends Object>(
    String key, [
    CacheMissHandler<T>? cacheMissHandler,
  ]) async => null;

  @override
  Future<void> invalidateGroup(String group) async {}

  @override
  Future<void> invalidateKey(String key) async {}

  @override
  List<String> get localKeys => [];

  @override
  int get localSize => 0;

  @override
  Future<void> put<T extends Object>(
    String key,
    T object, {
    Duration? lifetime,
    String? group,
  }) async {}
}
