import 'dart:ffi';

import 'package:serverpod/protocol.dart';

// TODO these are all stubs that should be replaced with a service that handles the functionality

/// Signature of a function that knows how to reload [RuntimeSettings]
typedef ReloadSettingsFunction = Future<Void> Function();

/// Signature of a function that knows how to update [RuntimeSettings]
typedef UpdateSettingsFunction = Future<Void> Function(RuntimeSettings);

/// Signature of a system shutdown function
typedef ShutdownFunction = Future<Void> Function();

/// Signature of a password access function
typedef PasswordAccessFunction = String Function(String);
