import 'package:serverpod_cli/src/analyzer/models/definitions.dart';

/// Utility class for filtering models.
abstract final class ModelFilterUtil {
  /// Returns all sealed top node classes.
  static Iterable<ClassDefinition> _getSealedTopNodeClasses(
    List<SerializableModelDefinition> models,
  ) {
    return models
        .whereType<ClassDefinition>()
        .where((element) => element.isSealedTopNode);
  }

  /// Returns a list of sealed hierarchies.
  /// Each hierarchy is represented by a list of classes.
  static Iterable<Iterable<ClassDefinition>> getSealedHierarchies(
    List<SerializableModelDefinition> models,
  ) {
    var sealedClasses = _getSealedTopNodeClasses(models);

    return sealedClasses.map(
      (element) {
        return [...element.descendantClasses, element];
      },
    );
  }

  /// Returns all classes that are not part of a sealed hierarchy.
  static Iterable<SerializableModelDefinition>
      getClassesWithoutSealedHierarchies(
    List<SerializableModelDefinition> models,
  ) {
    var sealedHierarchyClasses =
        getSealedHierarchies(models).expand((e) => e).toSet();

    return models.where(
      (e) => e is! ClassDefinition || !sealedHierarchyClasses.contains(e),
    );
  }
}
