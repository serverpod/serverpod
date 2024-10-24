import 'dart:io';
import 'package:serverpod_shared/serverpod_shared.dart';

void main() {
  var config = ServerpodConfig.load(
    'session_logs_no_db_development',
    'default',
    {},
  );
  stdout.write(config.toString());
}
