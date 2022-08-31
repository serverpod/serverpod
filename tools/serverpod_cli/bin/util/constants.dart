import 'dart:io';

/// Create command
const cmdCreate = 'create';

/// Generate command
const cmdGenerate = 'generate';

/// Run command
const cmdRun = 'run';

/// Certificates generate command
const cmdGenerateCertificates = 'generate-certs';

/// Shutdown command
const cmdShutdown = 'shutdown';

/// Logs command
const cmdLogs = 'logs';

/// Session logs command
const cmdSessionLogs = 'sessionlog';

/// Cache info command
const cmdCacheInfo = 'cacheinfo';

/// Server address command
const cmdServerAddress = 'serveraddress';

/// Server IDs command
const cmdServerIds = 'serverids';

/// Health check command
const cmdHealthCheck = 'healthcheck';

/// Pubspecs generate command
const cmdGeneratePubspecs = 'generate-pubspecs';

/// Serverpod run modes.
final runModes = <String>['development', 'staging', 'production'];

/// Getter for the Windows platform.
bool get isWindows => Platform.isWindows;

/// Getter for the macOS platform.
bool get isMacOs => Platform.isMacOS;

/// Getter for the Linux platform.
bool get isLinux => Platform.isLinux;
