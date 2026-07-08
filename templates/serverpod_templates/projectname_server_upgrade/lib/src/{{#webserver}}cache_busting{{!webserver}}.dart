import 'dart:io';

import 'package:serverpod/serverpod.dart';

final cacheBustingConfig = CacheBustingConfig(
  mountPrefix: '/web',
  fileSystemRoot: Directory(Uri(path: 'web/static').toFilePath()),
);
