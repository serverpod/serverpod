import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class RedisEndpoint extends Endpoint {
  Future<void> setSimpleData(
    Session session,
    String key,
    SimpleData data,
  ) async {
    await session.caches.global.put(key, data);
  }

  Future<void> setSimpleDataWithLifetime(
    Session session,
    String key,
    SimpleData data,
  ) async {
    await session.caches.global.put(
      key,
      data,
      lifetime: const Duration(seconds: 1),
    );
  }

  Future<SimpleData?> getSimpleData(Session session, String key) async {
    return (await session.caches.global.get<SimpleData>(key));
  }

  Future<void> deleteSimpleData(Session session, String key) async {
    await session.caches.global.invalidateKey(key);
  }

  Future<void> resetMessageCentralTest(Session session) async {}

  Future<SimpleData?> listenToChannel(Session session, String channel) async {
    SimpleData? data;

    // This line tests if listeners taking other types break the system;
    session.messages.addListener<TestEnum>(channel, (message) {});

    session.messages.addListener<SimpleData>(channel, (message) {
      data = message;
    });

    session.messages.addListener<SimpleData>(channel, (message) {
      throw Exception('Test exception');
    });

    // This line tests if listeners taking other types break the system;
    session.messages.addListener<TestEnum>(channel, (message) {});

    await Future.delayed(const Duration(seconds: 2));
    return data;
  }

  Future<void> postToChannel(
      Session session, String channel, SimpleData data) async {
    session.messages.postMessage(channel, data);
  }

  Future<int> countSubscribedChannels(Session session) async {
    return session.serverpod.redisController!.subscribedChannels.length;
  }
}
