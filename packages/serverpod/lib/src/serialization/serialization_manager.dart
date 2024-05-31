import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';

/// The [SerializationManager] is responsible for creating objects from a
/// serialization, but also for serializing objects. This class is typically
/// overridden by generated code. [SerializationManagerServer] is an extension to
/// also handle [Table]s.
abstract class SerializationManagerServer extends SerializationManager {
  /// The name of the module that defines the serialization.
  String getModuleName();

  /// Maps [Type]s to subclasses of [Table].
  Table? getTableForType(Type t);

  /// The desired structure of the database.
  List<TableDefinition> getTargetTableDefinitions();
}
