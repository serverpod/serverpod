import 'event_handler.dart';

/// Function signature type for functions that handle a [DiagnosticEvent].
///
/// Use together with [AsEventHandler] to adapt such a function to a
/// [DiagnosticEventHandler].
///
/// {@macro diagnostic_event_handler}
typedef EventHandlerFunction<T extends DiagnosticEvent> =
    void Function(
      T event, {
      required OriginSpace space,
      required DiagnosticEventContext context,
    });

/// Adapter class to use an [EventHandlerFunction] as a [DiagnosticEventHandler].
/// Since this class inherits [TypedEventHandler] it can filter on event type.
class AsEventHandler<T extends DiagnosticEvent> extends TypedEventHandler<T> {
  /// The function that handles the event.
  final EventHandlerFunction<T> handler;

  /// Creates a new [AsEventHandler] wrapping .
  const AsEventHandler(this.handler);

  @override
  void handleTypedEvent(
    T event, {
    required OriginSpace space,
    required DiagnosticEventContext context,
  }) {
    return handler(
      event,
      space: space,
      context: context,
    );
  }
}
