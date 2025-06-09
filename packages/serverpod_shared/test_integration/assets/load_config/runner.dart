import 'dart:io';
import 'package:serverpod_shared/serverpod_shared.dart';

void main() {
  var passwords = {
    'database': 'databasePassword',
    'redis': 'redisPassword',
    'serviceSecret': 'secret',
  };

  var config = ServerpodConfig.load('development', 'default', passwords);
  stdout.write(config.toString());
}
