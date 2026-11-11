import 'dart:async';

import 'package:serverpod/serverpod.dart';

class AuthenticatedStreamingTestEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Stream<int> openAuthenticatedStream(Session session) async* {
    int counter = 0;
    while (true) {
      yield ++counter;
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  Stream<String> watchAuthenticatedUserId(Session session) async* {
    yield session.authenticated!.userIdentifier;
    await Completer<void>().future;
  }
}
