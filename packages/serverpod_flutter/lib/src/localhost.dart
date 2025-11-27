import 'package:flutter/foundation.dart';

/// Returns the localhost address for the current platform.
String get localhost =>
    defaultTargetPlatform == TargetPlatform.android && !kIsWeb
    ? '10.0.2.2'
    : 'localhost';
