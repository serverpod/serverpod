import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';

var onErrorsCollector = (CodeGenerationCollector collector) {
  return (Uri uri, CodeGenerationCollector collected) {
    collector.addErrors(collected.errors);
  };
};

class StatefulAnalyzer {
  final Map<String, _ModelState> _modelStates = {};
  List<SerializableModelDefinition> _models = [];

  Function(Uri, CodeGenerationCollector)? _onErrorsChangedNotifier;

  StatefulAnalyzer(
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

  /// Returns all valid models in the state.
  List<SerializableModelDefinition> get _validModels => _modelStates.values
      .where((state) => state.errors.isEmpty)
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
    _models.removeWhere(
      (model) => model.sourceFileName == modelUri.path,
    );
  }

  /// Runs the validation on all models in the state. If no models are
  /// registered, this returns an empty list.
  /// Errors are reported through the [onErrorsChangedNotifier].
  List<SerializableModelDefinition> validateAll() {
    _updateAllModels();
    _validateAllModels();
    return _validModels;
  }

  /// Runs the validation on a single model. The model must exist in the
  /// state, if not this returns the last validated state.
  /// Errors are reported through the [onErrorsChangedNotifier].
  List<SerializableModelDefinition> validateModel(String yaml, Uri uri) {
    var state = _modelStates[uri.path];
    if (state == null) return _models;

    state.source.yaml = yaml;

    var doc = SerializableModelAnalyzer.extractModelDefinition(state.source);
    state.model = doc;
    if (doc != null) {
      _upsertModel(doc, uri);
    }

    // This can be optimized to only validate the files we know have related errors.
    _validateAllModels();
    return _validModels;
  }

  void _updateAllModels() {
    for (var state in _modelStates.values) {
      var model = SerializableModelAnalyzer.extractModelDefinition(
        state.source,
      );
      state.model = model;
    }

    _models = _modelStates.values
        .map((state) => state.model)
        .whereType<SerializableModelDefinition>()
        .toList();

    SerializableModelAnalyzer.resolveModelDependencies(_models);
  }

  void _upsertModel(
    SerializableModelDefinition model,
    Uri uri,
  ) {
    var index = _models.indexWhere(
      (element) => element.sourceFileName == uri.path,
    );
    if (index == -1) {
      _models.add(model);
    } else {
      _models[index] = model;
    }

    // Can be optimized to only resolve the model we know has changed.
    SerializableModelAnalyzer.resolveModelDependencies(_models);
  }

  void _validateAllModels() {
    for (var state in _modelStates.values) {
      var collector = CodeGenerationCollector();
      SerializableModelAnalyzer.validateYamlDefinition(
        state.source.yaml,
        state.source.yamlSourceUri,
        collector,
        state.model,
        _models,
      );

      if (collector.hasSeverErrors) {
        state.errors = collector.errors;
      } else {
        state.errors = [];
      }

      _onErrorsChangedNotifier?.call(
        state.source.yamlSourceUri,
        collector,
      );
    }
  }
}

class _ModelState {
  ModelSource source;
  List<SourceSpanException> errors = [];
  SerializableModelDefinition? model;

  _ModelState({
    required this.source,
  });
}
