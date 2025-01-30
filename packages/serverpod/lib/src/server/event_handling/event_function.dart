// ignore_for_file: public_member_api_docs
// TODO: Add documentation

import 'event_handler.dart';

typedef EventHandlerFunction<T extends ServerpodEvent> = void Function(
  T event,
  OriginSpace space, {
  required EventContext context,
});

/// Adapter class to use an [EventHandlerFunction] as an [EventHandler].
/// Also provides optional filtering on the [OriginSpace] of each event.
class AsEventHandler<T extends ServerpodEvent> extends TypedEventHandler<T> {
  final EventHandlerFunction<T> handler;
  final OriginSpace? spaceFilter;

  const AsEventHandler(
    this.handler, [
    this.spaceFilter,
  ]);

  @override
  void handleTypedEvent(
    T event,
    OriginSpace space, {
    required EventContext context,
  }) {
    if (spaceFilter == null || spaceFilter == space) {
      return handler(
        event,
        space,
        context: context,
      );
    }
  }
}
