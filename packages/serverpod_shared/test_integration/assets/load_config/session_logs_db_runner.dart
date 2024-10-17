import 'dart:io';
import 'package:serverpod_shared/serverpod_shared.dart';

void main() {
  var passwords = {
    'database': 'databasePassword',
  };

  var config = ServerpodConfig.load(
    'session_logs_db_development',
    'default',
    passwords,
  );
  stdout.write(config.toString());
}
