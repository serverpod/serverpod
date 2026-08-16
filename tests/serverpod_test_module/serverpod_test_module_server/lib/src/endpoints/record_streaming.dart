import 'dart:async';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class RecordStreamingEndpoint extends Endpoint {
  Stream<(int?, ModuleStreamingClass?)> streamModuleClass(
    Session session,
    Stream<(int?, ModuleStreamingClass?)> values,
  ) async* {
    await for (var value in values) {
      yield value;
    }
  }
}
