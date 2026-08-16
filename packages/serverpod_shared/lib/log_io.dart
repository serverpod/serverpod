/// Log writers that depend on `dart:io` / `dart:isolate` and therefore do
/// not work on the web. Import this in addition to
/// `package:serverpod_shared/serverpod_shared.dart` when you need
/// terminal-facing output or isolate-based writers.
library;

export 'package:serverpod_logging/serverpod_logging.dart';
