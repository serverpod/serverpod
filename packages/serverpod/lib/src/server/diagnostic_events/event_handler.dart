import 'package:meta/meta.dart';

/// Denotes whether an event's origin is application (user) space or framework space.
enum OriginSpace {
  /// Events that originate in the application code (user space).
  application,

  /// Events that originate in the framework code (framework space).
  framework,
}

/// Base interface for all diagnostic events.
abstract interface class DiagnosticEvent {}

/// An event that represents an exception that occurred in the server.
class ExceptionEvent implements DiagnosticEvent {
  /// The exception that occurred.
  final Object exception;

  /// The stack trace of the exception.
  final StackTrace stackTrace;

  /// An optional message associated with the exception.
  final String? message;

  /// Creates a new [ExceptionEvent].
  const ExceptionEvent(
    this.exception,
    this.stackTrace, {
    this.message,
  });

  /// Returns a string representation of this context.
  /// (The string separates the members with newlines.)
  @override
  String toString() {
    return '${message != null ? '$message\n' : ''}$exception\n$stackTrace';
  }
}

/// Base class for information about the context in which
/// a [DiagnosticEvent] was submitted.
///
/// Subclasses can add additional context information.
class DiagnosticEventContext {
  /// The id of the Serverpod server that submitted the event.
  final String serverId;

  /// The run mode of the Serverpodserver that submitted the event.
  final String serverRunMode;

  /// The name of the individual server that submitted the event.
  /// This is the empty string if the event is not associated with a specific server.
  final String serverName;

  /// Creates a new [DiagnosticEventContext].
  const DiagnosticEventContext({
    required this.serverId,
    required this.serverRunMode,
    required this.serverName,
  });

  /// Converts this context to a Json map representation, e.g. for logging or tags.
  Map<String, dynamic> toJson() {
    return {
      'serverId': serverId,
      'serverRunMode': serverRunMode,
      'serverName': serverName,
    };
  }

  /// Returns a string representation of this context.
  @override
  String toString() {
    return '$runtimeType($serverName, $serverId, $serverRunMode)';
  }
}

/// Base interface for [DiagnosticEvent] handlers.
///
/// {@template diagnostic_event_handler}
/// # Implementing diagnostic event handlers
///
/// [DiagnosticEventHandler] implementations are typically provided by the
/// developer to the [Serverpod] constructor upon startup.
///
/// Implementations can handle [DiagnosticEvent] instances of a specific
/// type or context, or all events.
///
/// ## Guidelines
///
/// An [DiagnosticEvent] represents an event that occurs in the server.
/// [DiagnosticEventHandler] implementations can react to these events
/// in order to gain insights into the behavior of the server.
///
/// As the name suggests the handlers should perform diagnostics only,
/// and not have any responsibilities that the regular functioning
/// of the server depends on.
///
/// The registered handlers are typically run concurrently,
/// can not depend on each other, and asynchronously -
/// they are not awaited by the operation they are triggered from.
///
/// If a handler throws an exception it will be logged to stderr
/// and otherwise ignored.
///
/// ## Time limits
///
/// Handlers should not run for an extended period of time.
/// Permitting that would risk accumulating resource consumption
/// and make the long-running performance of the server degrade.
/// This is especially true in situations of high load
/// or implementation issues causing a large number of events.
///
/// By default they are given a maximum of 30 seconds to complete.
/// This can be overridden by setting the diagnostic handler timeout
/// in the constructor of the [Serverpod] instance.
/// {@endtemplate}
abstract interface class DiagnosticEventHandler {
  /// Handles an event.
  void handleEvent(
    DiagnosticEvent event,
    OriginSpace space, {
    required DiagnosticEventContext context,
  });
}

/// A [DiagnosticEventHandler] that handles events of a specific type.
///
/// It will filter on the event type and ignore other events.
abstract class TypedEventHandler<T extends DiagnosticEvent>
    implements DiagnosticEventHandler {
  /// Creates a new [TypedEventHandler].
  const TypedEventHandler();

  /// Implements a filter on the handled event type.
  /// Should not be overridden by subclasses,
  /// override [handleTypedEvent] instead.
  @override
  @nonVirtual
  void handleEvent(
    DiagnosticEvent event,
    OriginSpace space, {
    required DiagnosticEventContext context,
  }) {
    if (event is T) {
      return handleTypedEvent(
        event,
        space,
        context: context,
      );
    }
  }

  /// Handles a typed event, called when the event type matches.
  /// To be implemented by subclasses.
  void handleTypedEvent(
    T event,
    OriginSpace space, {
    required DiagnosticEventContext context,
  });
}

/// A [DiagnosticEventHandler] that handles [ExceptionEvent] instances.
abstract class ExceptionHandler extends TypedEventHandler<ExceptionEvent> {}
