import 'event_handler.dart';

/// A record with a submitted diagnostic event.
class DiagnosticEventRecord<E extends DiagnosticEvent> {
  /// The event that was submitted.
  final E event;

  /// The origin space of the event.
  final OriginSpace space;

  /// The context of the event.
  final DiagnosticEventContext context;

  /// Creates a new [DiagnosticEventRecord].
  DiagnosticEventRecord(this.event, this.space, this.context);

  @override
  String toString() {
    return '$event  Origin is $space\n  Context is ${context.toJson()}';
  }
}
