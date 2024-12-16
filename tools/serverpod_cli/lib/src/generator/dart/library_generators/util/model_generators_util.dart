import 'package:code_builder/code_builder.dart';
import 'package:path/path.dart' as p;

import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/util/custom_allocators.dart';

/// A context to store models and their associated allocators.
/// Used during code generation to manage model-to-allocator relationships.
class ModelAllocatorContext {
  final List<ModelAllocatorEntry> _entries = [];

  /// Adds a [model] and its [allocator] to the context.
  void add(SerializableModelDefinition model, Allocator? allocator) {
    _entries.add(ModelAllocatorEntry(model: model, allocator: allocator));
  }

  /// Returns an immutable list of all entries in the context.
  List<ModelAllocatorEntry> get entries => List.unmodifiable(_entries);
}

/// Represents a single entry in the [ModelAllocatorContext],
/// containing a model and its corresponding allocator.
class ModelAllocatorEntry {
  final SerializableModelDefinition model;
  final Allocator? allocator;

  ModelAllocatorEntry({
    required this.model,
    required this.allocator,
  });
}

/// Provides utilities to process sealed hierarchies in models.
/// It filters, sorts, and associates models with allocators
/// within a [ModelAllocatorContext].
/// Or returns all models that are not part of a sealed hierarchy.
abstract class SealedHierarchiesProcessor {
  /// Processes sealed hierarchies in the provided [models].
  ///
  /// - Filters out sealed classes and their descendants from [models].
  /// - Sorts the hierarchy, instantiates and determines the appropriate [Allocator].
  /// - Adds the models and allocators to the provided [modelAllocatorContext].
  ///
  /// [config] is used to determine file paths and import structures.
  static void process(
    ModelAllocatorContext modelAllocatorContext,
    List<SerializableModelDefinition> models,
    GeneratorConfig config,
  ) {
    var sealedHierarchies = _getSealedHierarchies(models);

    for (var sealedHierarchy in sealedHierarchies) {
      var topNode = sealedHierarchy.first.sealedTopNode;

      if (topNode != null) {
        var importCollector = ImportCollector(
          topNode.getFullFilePath(config, false),
        );

        for (var model in sealedHierarchy) {
          var currentPath = model.getFullFilePath(config, false);

          var partOfAllocator = PartOfAllocator(
            currentPath: currentPath,
            importCollector: importCollector,
          );

          modelAllocatorContext.add(
            model,
            model.isSealedTopNode
                ? PartAllocator(partOfAllocator: partOfAllocator)
                : partOfAllocator,
          );
        }
      }
    }
  }

  /// Returns all classes from `models` are not part of a sealed hierarchy.
  static Iterable<SerializableModelDefinition> getNonSealedClasses(
    List<SerializableModelDefinition> models,
  ) {
    var sealedHierarchyClasses =
        _getSealedHierarchies(models).expand((e) => e).toSet();

    return models.where(
      (e) => e is! ClassDefinition || !sealedHierarchyClasses.contains(e),
    );
  }

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
  static Iterable<Iterable<ClassDefinition>> _getSealedHierarchies(
    List<SerializableModelDefinition> models,
  ) {
    var sealedClasses = _getSealedTopNodeClasses(models);

    return sealedClasses.map(
      (element) {
        return [...element.descendantClasses, element];
      },
    );
  }
}

/// An extension on `SerializableModelDefinition` to compute the file path
/// where the model will be located.
extension SerializableModelPath on SerializableModelDefinition {
  /// Returns a String with the file path.
  /// Consisting of `subDirParts` + `filename.dart`
  String get filePath => p.joinAll([
        ...subDirParts,
        '$fileName.dart',
      ]);

  /// Returns a String with the server or client path parts followed by
  /// `filePath`.
  String getFullFilePath(GeneratorConfig config, bool serverCode) {
    return p.joinAll([
      ...serverCode
          ? config.generatedServeModelPathParts
          : config.generatedDartClientModelPathParts,
      filePath,
    ]);
  }
}
