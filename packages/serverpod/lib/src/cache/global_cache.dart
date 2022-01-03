import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/cache/cache.dart';

abstract class GlobalCache extends Cache {
  GlobalCache(
    int maxLocalEntries,
    SerializationManager serializationManager,
  ) : super(
          maxLocalEntries,
          serializationManager,
        );
}
