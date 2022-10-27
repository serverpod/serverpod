import 'package:serverpod/serverpod.dart';

/// The [SerializationManager] is responsible for creating objects from a
/// serialization, but also for serializing objects. This class is typically
/// overriden by generated code. [SerializationManagerServer] is an extension to
/// also handle [Table]s.
abstract class SerializationManagerServer extends SerializationManager {
  /// Maps [Type]s to subclasses of [Table].
  Table? getTableForType(Type t);
}
