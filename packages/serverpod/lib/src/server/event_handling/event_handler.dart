// ignore_for_file: public_member_api_docs
// TODO: Add documentation

/// Indicate whether an event's origin is application / user space or framework space.
enum OriginSpace {
  /// Events that originate in the application code (user space).
  application,

  /// Events that originate in the framework code (framework space).
  framework,
}

abstract interface class ServerpodEvent {}

class ExceptionEvent implements ServerpodEvent {
  final Object exception;
  final StackTrace stackTrace;
  final String? message;

  const ExceptionEvent(
    this.exception,
    this.stackTrace, {
    this.message,
  });
}

class EventContext {
  final String serverName;
  final String serverId;
  final String serverRunMode;

  const EventContext({
    required this.serverName,
    required this.serverId,
    required this.serverRunMode,
  });

  /// Converts this context to a string map, e.g. for logging or tags.
  Map<String, String> toMap() {
    return {
      'serverName': serverName,
      'serverId': serverId,
      'serverRunMode': serverRunMode,
    };
  }

  @override
  String toString() {
    return 'EventContext($serverName, $serverId, $serverRunMode)';
  }
}

abstract interface class EventHandler {
  void handleEvent(
    ServerpodEvent event,
    OriginSpace space, {
    required EventContext context,
  });
}

abstract class TypedEventHandler<T extends ServerpodEvent>
    implements EventHandler {
  const TypedEventHandler();

  @override
  void handleEvent(
    ServerpodEvent event,
    OriginSpace space, {
    required EventContext context,
  }) {
    if (event is T) {
      return handleTypedEvent(
        event,
        space,
        context: context,
      );
    }
  }

  void handleTypedEvent(
    T event,
    OriginSpace space, {
    required EventContext context,
  });
}

abstract class ExceptionHandler extends TypedEventHandler<ExceptionEvent> {}
