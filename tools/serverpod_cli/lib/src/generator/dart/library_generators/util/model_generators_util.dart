import 'package:path/path.dart' as p;

import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/util/custom_allocators.dart';

/// Represents a single entry in the [ModelAllocatorContext],
/// containing a model and its corresponding allocator.
class ModelAllocatorEntry {
  final SerializableModelDefinition model;
  final AssigningAllocator allocator;

  ModelAllocatorEntry({
    required this.model,
    required this.allocator,
  });
}

/// Manages the relationship between models and their allocators.
/// Includes a factory constructor for creating a context from
/// a list of `SerializableModelDefinition` and `GeneratorConfig`.
class ModelAllocatorContext {
  ModelAllocatorContext(this._entries);

  final List<ModelAllocatorEntry> _entries;

  List<ModelAllocatorEntry> get entries => List.unmodifiable(_entries);

  /// Factory constructor to build a [ModelAllocatorContext]
  /// from a list of models and a configuration.
  ///
  /// [resolveUrl] is forwarded to the allocators, see
  /// [StableImportAllocator.new].
  factory ModelAllocatorContext.build(
    List<SerializableModelDefinition> models,
    GeneratorConfig config, {
    String Function(String url)? resolveUrl,
  }) {
    var entries = <ModelAllocatorEntry>[];

    var sealedHierarchies = _getSealedHierarchies(models);

    for (var sealedHierarchy in sealedHierarchies) {
      var topNode = sealedHierarchy.first.sealedTopNode;

      if (topNode != null) {
        var importCollector = ImportCollector(
          topNode.getFullFilePath(config, serverCode: false),
          resolveUrl: resolveUrl,
        );

        for (var model in sealedHierarchy) {
          var currentPath = model.getFullFilePath(config, serverCode: false);

          var partOfAllocator = PartOfAllocator(
            currentPath: currentPath,
            importCollector: importCollector,
          );

          entries.add(
            ModelAllocatorEntry(
              model: model,
              allocator: model.isSealedTopNode
                  ? PartAllocator(partOfAllocator: partOfAllocator)
                  : partOfAllocator,
            ),
          );
        }
      }
    }

    var modelsWithoutSealedHierarchies = _getNonSealedClasses(models);

    for (var model in modelsWithoutSealedHierarchies) {
      entries.add(
        ModelAllocatorEntry(
          model: model,
          allocator: StableImportAllocator(resolveUrl: resolveUrl),
        ),
      );
    }

    return ModelAllocatorContext(entries);
  }

  /// Returns all classes from `models` are not part of a sealed hierarchy.
  static Iterable<SerializableModelDefinition> _getNonSealedClasses(
    List<SerializableModelDefinition> models,
  ) {
    return models.where(
      (e) => e is! ClassDefinition || e.sealedTopNode == null,
    );
  }

  /// Returns all sealed top node classes.
  static Iterable<ClassDefinition> _getSealedTopNodeClasses(
    List<SerializableModelDefinition> models,
  ) {
    return models.whereType<ClassDefinition>().where(
      (element) => element.isSealedTopNode,
    );
  }

  /// Returns a list of sealed hierarchies.
  /// Each hierarchy is represented by a list of classes.
  ///
  /// The top node comes last. Everything in a sealed hierarchy is emitted into
  /// the top node's library, which is the one that writes the import
  /// directives for all of them.
  ///
  /// Generation order is not a correctness requirement: prefixes are assigned
  /// from the complete set of imports the hierarchy needs, which every member
  /// contributes to before any of them is generated.
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

  /// Returns a String with the full server or client path followed by
  /// `filename.dart`. When the model is a shared model, returns the path inside
  /// the shared package's generated directory.
  String getFullFilePath(GeneratorConfig config, {required bool serverCode}) {
    if (isSharedModel && sharedPackageName != null) {
      var pathParts = config.sharedModelsSourcePathsParts[sharedPackageName];
      if (pathParts != null) {
        return p.joinAll([
          ...config.serverPackageDirectoryPathParts,
          ...pathParts,
          'lib',
          'src',
          'generated',
          filePath,
        ]);
      }
    }

    return p.joinAll([
      ...serverCode
          ? config.generatedServeModelPathParts
          : config.generatedDartClientModelPathParts,
      filePath,
    ]);
  }
}
