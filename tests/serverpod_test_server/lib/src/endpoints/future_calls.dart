import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class FutureCallsEndpoint extends Endpoint {
  Future<void> makeFutureCall(Session session, SimpleData? data) async {
    await session.serverpod.futureCallWithDelay(
      'testCall',
      data,
      const Duration(seconds: 1),
    );
  }
}
