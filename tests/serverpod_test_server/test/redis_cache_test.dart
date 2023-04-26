import 'package:serverpod/src/cache/redis_cache.dart';
import 'package:serverpod/src/redis/controller.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  Protocol serializationManager;
  late RedisCache cache;
  MockRedisController mockRedisController = MockRedisController();
  List entries = [null, '{"num":0}'];

  setUp(() {
    serializationManager = Protocol();

    cache = RedisCache(serializationManager, mockRedisController);

    when(() => mockRedisController.get('entry')).thenAnswer((_) async {
      return entries.removeAt(0);
    });

    when(() => mockRedisController.set(any(), any(), lifetime: any(named: 'lifetime'))).thenAnswer((_) async {
      return Future.value(true);
    });
  });

  test('Fetch an object from cache and write it to cache if it is missing', () async {
    var entry = SimpleData(num: 0);

    var retrieved = await cache.fetch('entry', () async {
      return entry;
    });
    expect(retrieved!.num, equals(0));

    retrieved = await cache.fetch('entry', () async {
      return SimpleData(num: 1);
    });
    expect(retrieved!.num, equals(0));
  });
}

class MockRedisController extends Mock implements RedisController {}
