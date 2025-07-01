import 'dart:async';

import 'package:serverpod/serverpod.dart';

class TestExceptionHandler extends ExceptionHandler {
  final eventsStreamController =
      StreamController<DiagnosticEventRecord<ExceptionEvent>>();

  Stream<DiagnosticEventRecord<ExceptionEvent>> get events =>
      eventsStreamController.stream;

  @override
  Future<void> handleTypedEvent(
    ExceptionEvent event, {
    required OriginSpace space,
    required DiagnosticEventContext context,
  }) async {
    eventsStreamController.add(DiagnosticEventRecord(event, space, context));
  }
}
