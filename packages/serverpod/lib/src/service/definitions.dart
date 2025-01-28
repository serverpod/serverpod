import 'dart:ffi';

// TODO these are all stubs that should be replaced with a service that handles the functionality

/// Signature of a system shutdown function
typedef ShutdownFunction = Future<Void> Function();

/// Signature of a password access function
typedef PasswordAccessFunction = String Function(String);
