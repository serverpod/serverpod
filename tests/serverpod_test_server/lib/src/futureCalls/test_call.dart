import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class TestCall extends FutureCall<SimpleData> {
  final Completer<void> completer = Completer<void>();

  @override
  Future<void> invoke(Session session, SimpleData? object) async {
    if (object != null) {
      var data = object;
      session.log('${data.num}');
    } else {
      session.log('null');
    }

    completer.complete();
  }
}
