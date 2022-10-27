import 'package:serverpod/serverpod.dart';

/// The [SerializationManager] is responsible for creating objects from a
/// serialization, but also for serializing objects. This class is typically
/// overriden by generated code. [SerializationManagerServer] is an extension to
/// also handle [Table]s.
abstract class SerializationManagerServer extends SerializationManager {
  // /// Maps database table names to class names.
  // Map<String, String> get tableClassMapping;

  // Map<Type, Table> get typeTableMapping;

  /// Maps [Type]s to subclasses of [Table].
  Table? getTableForType(Type t);

  // // @override
  // void merge(SerializationManager other, String classNamePrefix) {
  //   // super.merge(other, classNamePrefix);
  //   if (other is SerializationManagerServer) {
  //     // _appendTableClassMapping(other.tableClassMapping);
  //     _appendTypeTableMapping(other.typeTableMapping);
  //   }
  // }

  // // void _appendTableClassMapping(Map<String, String> map) {
  // //   for (var tableName in map.keys) {
  // //     // tableClassMapping[tableName] = map[tableName]!;
  // //   }
  // // }

  // void _appendTypeTableMapping(Map<Type, Table> map) {
  //   for (var type in map.keys) {
  //     typeTableMapping.putIfAbsent(type, () => map[type]!);
  //   }
  // }
}
