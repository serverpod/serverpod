import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/model_relations.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';

var onErrorsCollector = (CodeGenerationCollector collector) {
  return (Uri uri, CodeGenerationCollector collected) {
    collector.addErrors(collected.errors);
  };
};

class StatefulAnalyzer {
  final GeneratorConfig config;
  final Map<String, _ModelState> _modelStates = {};

  /// Returns true if any of the models have severe errors.
  bool get hasSevereErrors => _modelStates.values.any(
    (state) => CodeAnalysisCollector.containsSevereErrors(state.errors),
  );

  Function(Uri, CodeGenerationCollector)? _onErrorsChangedNotifier;

  StatefulAnalyzer(
    this.config,
    List<ModelSource> sources, [
    Function(Uri, CodeGenerationCollector)? onErrorsChangedNotifier,
  ]) {
    for (var yamlSource in sources) {
      _modelStates[yamlSource.yamlSourceUri.path] = _ModelState(
        source: yamlSource,
      );
    }

    _onErrorsChangedNotifier = onErrorsChangedNotifier;
  }

  /// Returns all valid models in the state that are part of the project.
  List<SerializableModelDefinition> get _validProjectModels => _modelStates
      .values
      .where(
        (state) => !CodeAnalysisCollector.containsSevereErrors(state.errors),
      )
      .where(
        (state) =>
            state.source.moduleAlias == defaultModuleAlias ||
            state.source.isSharedModel,
      )
      .map((state) => state.model)
      .whereType<SerializableModelDefinition>()
      .toList();

  /// Returns all models in the state.
  List<SerializableModelDefinition> get _models => _modelStates.values
      .map((state) => state.model)
      .whereType<SerializableModelDefinition>()
      .toList();

  /// Adds a new model to the state but leaves the responsibility of validating
  /// it to the caller. Please note that [validateAll] should be called to
  /// guarantee that all errors are found.
  void addYamlModel(ModelSource yamlSource) {
    var modelState = _ModelState(
      source: yamlSource,
    );

    _modelStates[yamlSource.yamlSourceUri.path] = modelState;
  }

  /// Checks if a model is registered in the state.
  bool isModelRegistered(Uri uri) {
    return _modelStates.containsKey(uri.path);
  }

  /// Removes a model from the state but leaves the responsibility of validating
  /// the new state to the caller. Please note that [validateAll] should be called to
  /// guarantee that all related errors are cleared.
  void removeYamlModel(Uri modelUri) {
    _modelStates.remove(modelUri.path);
  }

  /// Runs the validation on all models in the state. If no models are
  /// registered, this returns an empty list.
  /// Errors are reported through the [onErrorsChangedNotifier].
  ///
  /// When [reportIssuesForPaths] is non-null (incremental watch runs), hint- and
  /// info-level issues are only reported for model files in that set. Errors and
  /// warnings are still reported for every file. When null, all issues are
  /// reported (full `serverpod generate` / initial watch generation).
  List<SerializableModelDefinition> validateAll({
    Set<String>? reportIssuesForPaths,
  }) {
    _updateAllModels();
    _validateAllModels(reportIssuesForPaths: reportIssuesForPaths);
    return _validProjectModels;
  }

  /// Runs the validation on a single model. The model must exist in the
  /// state, if not this returns the last validated state.
  /// Errors are reported through the [onErrorsChangedNotifier].
  List<SerializableModelDefinition> validateModel(String yaml, Uri uri) {
    var state = _modelStates[uri.path];
    if (state == null) return _validProjectModels;

    state.source.yaml = yaml;

    var doc = SerializableModelAnalyzer.extractModelDefinition(
      state.source,
      config.extraClasses,
    );
    state.model = doc;

    // Can be optimized to only resolve the model we know has changed.
    SerializableModelAnalyzer.resolveModelDependencies(_models);

    // This can be optimized to only validate the files we know have related errors.
    _validateAllModels(reportIssuesForPaths: null);
    return _validProjectModels;
  }

  void _updateAllModels() {
    for (var state in _modelStates.values) {
      var model = SerializableModelAnalyzer.extractModelDefinition(
        state.source,
        config.extraClasses,
      );
      state.model = model;
    }

    SerializableModelAnalyzer.resolveModelDependencies(_models);
  }

  void _validateAllModels({Set<String>? reportIssuesForPaths}) {
    var modelsToValidate = _modelStates.values.where(
      (state) =>
          state.source.moduleAlias == defaultModuleAlias ||
          state.source.isSharedModel,
    );
    var modelsWithDocumentPath = _modelStates.values
        .map(
          (state) => (
            documentPath: state.source.yamlSourceUri.path,
            model: state.model,
          ),
        )
        .whereType<ModelWithDocumentPath>()
        .toList();

    var parsedModels = ParsedModelsCollection(modelsWithDocumentPath);

    for (var state in modelsToValidate) {
      var collector = CodeGenerationCollector();
      SerializableModelAnalyzer.validateYamlDefinition(
        config,
        state.source.yaml,
        state.source.yamlSourceUri,
        collector,
        state.model,
        parsedModels,
      );

      if (collector.hasSevereErrors) {
        state.errors = collector.errors;
      } else {
        state.errors = [];
      }

      _notifyModelIssues(
        state.source.yamlSourceUri,
        collector,
        reportIssuesForPaths,
      );
    }
  }

  /// Notifies for every model when [scope] is null (including empty collectors).
  /// With a non-null [scope], out-of-scope models are only notified when they
  /// still have error or warning severity issues; hint/info for unchanged files
  /// is suppressed.
  void _notifyModelIssues(
    Uri modelUri,
    CodeGenerationCollector collector,
    Set<String>? scope,
  ) {
    if (scope == null || _isUriPathInSet(modelUri, scope)) {
      _onErrorsChangedNotifier?.call(modelUri, collector);
      return;
    }

    final filtered = CodeGenerationCollector();
    filtered.addErrors(
      collector.errors.where((e) {
        if (e is! SourceSpanSeverityException) return true;
        return e.severity == SourceSpanSeverity.error ||
            e.severity == SourceSpanSeverity.warning;
      }).toList(),
    );

    if (filtered.errors.isNotEmpty) {
      _onErrorsChangedNotifier?.call(modelUri, filtered);
    }
  }
}

bool _isUriPathInSet(Uri uri, Set<String> paths) {
  final modelPath = p.normalize(p.absolute(uri.toFilePath()));
  return paths.any((affected) {
    return p.normalize(p.absolute(affected)) == modelPath;
  });
}

class _ModelState {
  ModelSource source;
  List<SourceSpanException> errors = [];
  SerializableModelDefinition? model;

  _ModelState({
    required this.source,
  });
}
