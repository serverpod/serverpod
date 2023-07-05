import 'dart:io';

/// Returns the localhost address for the current platform.
String get localhost => Platform.isAndroid ? '10.0.2.2' : 'localhost';
