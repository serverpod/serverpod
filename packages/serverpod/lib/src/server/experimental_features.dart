import 'diagnostic_events/event_handler.dart';

/// Setup of experimental features.
///
/// Experimental features are not yet stable and may change or be removed.
class ExperimentalFeatures {
  /// List of [DiagnosticEventHandler] that will be called for all diagnostic events.
  final List<DiagnosticEventHandler>? diagnosticEventHandlers;

  /// Creates a new [ExperimentalFeatures] instance.
  ExperimentalFeatures({this.diagnosticEventHandlers});
}
