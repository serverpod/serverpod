import 'dart:io';

import 'package:meta/meta.dart';
import 'package:serverpod_shared/log.dart';
import 'package:serverpod_shared/log_io.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import 'log_writers/database_session_log_writer.dart';
import 'log_writers/json_session_log_writer.dart';
import 'log_writers/text_session_log_writer.dart';
import 'log_writers/vm_service_log_writer.dart';
import 'log_writers/vm_service_session_log_writer.dart';
import 'session_log.dart';

/// Handle for a set of log writers installed on the global chains.
/// Construct directly and populate via [addLogWriter] /
/// [addSessionLogWriter], or call [installDefaults] to get the standard
/// Serverpod bundle. [close] tears the set down again.
///
/// Ownership belongs to the caller (typically `main.dart` or a test
/// harness). Call [close] during teardown to remove and dispose exactly
/// the writers this setup added, leaving the globals in their prior state.
class ServerpodLogSetup {
  /// Creates an empty setup. Add writers via [addLogWriter] /
  /// [addSessionLogWriter]; call [close] during teardown.
  ServerpodLogSetup();

  /// Installs the framework-level writers (text to stdout/stderr, plus
  /// [VmServiceLogWriter] for TUI consumers) and the always-on session
  /// VM-service writer. Session-chain writers that depend on config
  /// (text vs json echo, database persistence) are added later by
  /// [Serverpod] via [applyConfig].
  static ServerpodLogSetup installDefaults() {
    final setup = ServerpodLogSetup();
    setup.addLogWriter(
      stdout.hasTerminal
          ? IsolatedLogWriter(TextLogWriter.new)
          : TextLogWriter(),
    );
    setup.addLogWriter(VmServiceLogWriter());
    setup.addSessionLogWriter(VmServiceSessionLogWriter());
    return setup;
  }

  final List<LogWriter> _logWriters = [];
  final List<SessionLogWriter> _sessionWriters = [];
  DatabaseSessionLogWriter? _databaseWriter;
  bool _closed = false;

  /// The [DatabaseSessionLogWriter] added by [applyConfig], or null if
  /// persistence is disabled or unsupported for the configured dialect.
  /// [Serverpod] reads this to attach its internal [Session] once the
  /// database pool is up.
  DatabaseSessionLogWriter? get databaseWriter => _databaseWriter;

  /// Adds [writer] to the global [logWriter] chain and tracks it so
  /// [close] removes and disposes it.
  void addLogWriter(LogWriter writer) {
    _ensureOpen();
    logWriter.add(writer);
    _logWriters.add(writer);
  }

  /// Adds [writer] to the global [sessionLogWriter] chain and tracks
  /// it so [close] removes and disposes it.
  void addSessionLogWriter(SessionLogWriter writer) {
    _ensureOpen();
    sessionLogWriter.add(writer);
    _sessionWriters.add(writer);
  }

  /// Adds the config-dependent session writers: text/json echo (if
  /// `consoleEnabled`) and [DatabaseSessionLogWriter] (if
  /// `persistentEnabled` and the dialect supports it). Called once by
  /// [Serverpod] after its config is loaded.
  @internal
  void applyConfig(ServerpodConfig config) {
    _ensureOpen();
    final sessionLogs = config.sessionLogs;
    if (sessionLogs.consoleEnabled) {
      addSessionLogWriter(switch (sessionLogs.consoleLogFormat) {
        ConsoleLogFormat.text => TextSessionLogWriter(),
        ConsoleLogFormat.json => JsonSessionLogWriter(),
      });
    }
    final dbConfig = config.database;
    if (sessionLogs.persistentEnabled &&
        dbConfig != null &&
        dbConfig.dialect != DatabaseDialect.sqlite) {
      final dbWriter = DatabaseSessionLogWriter();
      _databaseWriter = dbWriter;
      addSessionLogWriter(dbWriter);
    }
  }

  /// Closes isolate-based writers (so they release their isolates) and
  /// leaves the globals in the state they were in before [installDefaults]
  /// ran - so a subsequent setup, a second Serverpod, or a test tear-down
  /// starts from a clean chain.
  ///
  /// Idempotent.
  Future<void> close() async {
    if (_closed) return;
    _closed = true;

    await (log.flush(), sessionLog.flush()).wait;

    for (final w in _logWriters) {
      logWriter.remove(w);
    }
    for (final w in _sessionWriters) {
      sessionLogWriter.remove(w);
    }
    await [
      ..._logWriters.map((w) => w.close()),
      ..._sessionWriters.map((w) => w.dispose()),
    ].wait;

    _logWriters.clear();
    _sessionWriters.clear();
    _databaseWriter = null;
  }

  void _ensureOpen() {
    if (_closed) {
      throw StateError('ServerpodLogSetup has been closed.');
    }
  }
}
