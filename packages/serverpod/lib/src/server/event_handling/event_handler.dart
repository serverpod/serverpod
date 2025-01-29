// ignore_for_file: public_member_api_docs
// TODO: Add documentation

import 'package:serverpod/serverpod.dart';

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

EventContext contextFromServer(Server server) {
  return EventContext(
    serverName: server.name,
    serverId: server.serverId,
    serverRunMode: server.runMode,
  );
}

typedef EventHandler = Future<void> Function(
  ServerpodEvent event,
  OriginSpace space, {
  required EventContext context,
});

abstract interface class EventHandlerCallable {
  Future<void> call(
    ServerpodEvent event,
    OriginSpace space, {
    required EventContext context,
  });
}

typedef ExceptionHandler = Future<void> Function(
  ExceptionEvent event,
  OriginSpace space, {
  required EventContext context,
});

abstract interface class ExceptionHandlerCallable {
  Future<void> call(
    ExceptionEvent event,
    OriginSpace space, {
    required EventContext context,
  });
}

/// Adapter class to use an [ExceptionHandler] as an [EventHandler].
/// Also provides optional filtering on the [OriginSpace] of each event.
class ExceptionEventHandler implements EventHandlerCallable {
  final ExceptionHandler handler;
  final OriginSpace? spaceFilter;

  const ExceptionEventHandler(
    this.handler, [
    this.spaceFilter,
  ]);

  @override
  Future<void> call(
    ServerpodEvent event,
    OriginSpace space, {
    required EventContext context,
  }) {
    if ((spaceFilter == null || spaceFilter == space) &&
        event is ExceptionEvent) {
      return handler(
        event,
        space,
        context: context,
      );
    }
    return Future.value();
  }
}
