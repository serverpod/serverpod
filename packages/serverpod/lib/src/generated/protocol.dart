/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

library protocol;

import 'package:serverpod/serverpod.dart';

import 'future_call_entry.dart';
import 'distributed_cache_entry.dart';

export 'future_call_entry.dart';
export 'distributed_cache_entry.dart';

class Protocol extends SerializationManager {
  static final Protocol instance = Protocol();

  Map<String, constructor> _constructors = <String, constructor>{};
  Map<String, constructor> get constructors => _constructors;

  Protocol() {
    constructors['FutureCallEntry'] = (Map<String, dynamic> serialization) => FutureCallEntry.fromSerialization(serialization);
    constructors['DistributedCacheEntry'] = (Map<String, dynamic> serialization) => DistributedCacheEntry.fromSerialization(serialization);
  }
}
