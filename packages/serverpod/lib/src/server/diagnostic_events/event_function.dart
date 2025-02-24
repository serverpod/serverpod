import 'event_handler.dart';

/// Function signature type for functions that handle a [DiagnosticEvent].
///
/// Use together with [AsEventHandler] to adapt such a function to a
/// [DiagnosticEventHandler].
///
/// {@macro diagnostic_event_handler}
typedef EventHandlerFunction<T extends DiagnosticEvent> = void Function(
  T event, {
  required OriginSpace space,
  required DiagnosticEventContext context,
});

/// Adapter class to use an [EventHandlerFunction] as a [DiagnosticEventHandler].
/// Since this class inherits [TypedEventHandler] it can filter on event type.
/// It also provides optional filtering on the [OriginSpace] of each event.
class AsEventHandler<T extends DiagnosticEvent> extends TypedEventHandler<T> {
  /// The function that handles the event.
  final EventHandlerFunction<T> handler;

  /// Optional filter to only handle events of a specific [OriginSpace].
  final OriginSpace? spaceFilter;

  /// Creates a new [AsEventHandler] wrapping .
  const AsEventHandler(
    this.handler, [
    this.spaceFilter,
  ]);

  @override
  void handleTypedEvent(
    T event, {
    required OriginSpace space,
    required DiagnosticEventContext context,
  }) {
    if (spaceFilter == null || spaceFilter == space) {
      return handler(
        event,
        space: space,
        context: context,
      );
    }
  }
}
