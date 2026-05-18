import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_shared/serverpod_shared.dart';

import '../transport.dart';

/// BEGIN/END markers for our managed block in `postgresql.conf`. Rewrites
/// touch only lines between (and including) these markers; everything else
/// is preserved verbatim.
const String confBlockBeginMarker =
    '# >>> serverpod_embedded_postgres BEGIN - DO NOT EDIT';

/// END marker for our managed block in `postgresql.conf`. Pairs with
/// [confBlockBeginMarker].
const String confBlockEndMarker = '# <<< serverpod_embedded_postgres END';

/// Builds the body of our managed `postgresql.conf` block for [transport].
///
/// [pgDataDir] is the absolute PGDATA path, used to compute the relative
/// socket directory for [UnixTransport]: PG `chdir`s to PGDATA before
/// binding, so a relative path keeps `sun_path` ~20 bytes regardless of
/// project depth.
String buildPostgresConfBody({
  required Transport transport,
  required Directory pgDataDir,
}) {
  var transportSection = switch (transport) {
    UnixTransport() => _udsTransportSection(pgDataDir: pgDataDir),
    TcpTransport(:final port) => _tcpTransportSection(port: port),
  };

  return '''
cluster_name = 'serverpod_dev'

# Resources (laptop-friendly)
shared_buffers = 128MB
work_mem = 4MB
maintenance_work_mem = 64MB

# Logging
log_min_messages = warning
log_min_error_statement = error
log_connections = off
log_disconnections = off
log_statement = 'none'
log_destination = 'stderr'
logging_collector = off

# Durability (dev)
fsync = on
synchronous_commit = off
full_page_writes = on

# Maintenance
autovacuum = on
autovacuum_naptime = 60s

# Misc
max_connections = 100
shared_preload_libraries = ''

# Transport ($transport)
$transportSection''';
}

String _udsTransportSection({required Directory pgDataDir}) {
  // Sibling layout convention: <root>/pgdata is PGDATA, <root>/run is the
  // UDS directory. Compute the relative path from PGDATA so PG's bind
  // sun_path stays short.
  var runDir = Directory(p.join(pgDataDir.parent.path, 'run'));
  var relativeSocketDir = shortestPathRelativeTo(
    runDir.path,
    from: pgDataDir.path,
  );
  // PG parses C-style escapes inside quoted .conf strings (`\r` -> CR),
  // so a Windows-native `..\run` mangles the path. Re-join with POSIX
  // separators and then run through the conf-string escape for any
  // residual `'` / `\` (legal in Linux project paths).
  var posixSocketDir = p.posix.joinAll(p.split(relativeSocketDir));
  return """
listen_addresses = ''
unix_socket_directories = '${_quoteConfString(posixSocketDir)}'
unix_socket_permissions = 0700
""";
}

/// Escapes a string for use inside a single-quoted PostgreSQL .conf
/// value. Per PG's conf parser, backslashes are doubled and single
/// quotes are doubled. Other escape sequences (`\n`, `\r`, `\t`, `\xnn`)
/// remain interpreted - but since we always emit the backslash-doubled
/// form, no literal backslash in [s] can be misread as an escape lead-in.
String _quoteConfString(String s) =>
    s.replaceAll(r'\', r'\\').replaceAll("'", "''");

String _tcpTransportSection({required int port}) {
  return """
listen_addresses = '127.0.0.1'
unix_socket_directories = ''
port = $port
""";
}

/// Idempotent rewriter for a single managed block in [original].
///
/// If the markers exist, the block between them is replaced with [body]
/// (with the markers restored). Otherwise, the block is appended at the
/// end of the file. Lines outside the block are preserved verbatim.
String rewriteManagedBlock(String original, String body) {
  var managed = '$confBlockBeginMarker\n$body$confBlockEndMarker\n';

  var beginIdx = original.indexOf(confBlockBeginMarker);
  if (beginIdx == -1) {
    var separator = (original.isEmpty || original.endsWith('\n')) ? '' : '\n';
    return '$original$separator\n$managed';
  }

  var endIdx = original.indexOf(confBlockEndMarker, beginIdx);
  if (endIdx == -1) {
    throw StateError(
      'postgresql.conf: managed block has BEGIN marker but no matching '
      'END marker. Refusing to rewrite to avoid clobbering user data.',
    );
  }
  var afterEnd = endIdx + confBlockEndMarker.length;
  // Consume the marker's trailing line ending (LF, CR, or CRLF) so a
  // Windows-saved file doesn't leave a stray \r when we splice in a
  // body that uses LF.
  if (afterEnd < original.length && original[afterEnd] == '\r') {
    afterEnd++;
  }
  if (afterEnd < original.length && original[afterEnd] == '\n') {
    afterEnd++;
  }

  return original.substring(0, beginIdx) +
      managed +
      original.substring(afterEnd);
}
