import 'log.dart';
import 'log_types.dart';

/// Global writer chain that backs [log]. Callers configure the chain by
/// adding writers with [MultiLogWriter.add] and removing them with
/// [MultiLogWriter.remove]; identity is stable for the process lifetime,
/// so the chain is shared across any number of [Log] consumers and
/// framework bootstraps.
///
/// ```dart
/// logWriter.add(MyLogWriter());
/// log.info('Server started');
/// ```
final MultiLogWriter logWriter = MultiLogWriter([]);

/// Global [Log] that forwards to [logWriter]. Identity is stable: the
/// instance is constructed at library init and never reassigned. Entry
/// points configure logging by mutating [logWriter], not by replacing
/// [log].
final Log log = Log(logWriter, logLevel: LogLevel.info);
