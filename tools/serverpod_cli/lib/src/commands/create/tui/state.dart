import 'package:serverpod_cli/src/commands/create/tui/config.dart';
import 'package:serverpod_cli/src/commands/tui/bounded_queue_list.dart';
import 'package:serverpod_cli/src/commands/tui/state.dart';
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/template_context.dart';

/// Central state for [ServerpodCreateApp] rendered by nocterm.
class CreateConfigState extends ServerpodState {
  CreateConfigState(ServerpodTemplateType template) {
    _resetState(template);
  }

  late final List<ServerpodCreateConfig> configValues = [];

  /// Tracked state for selected [ConfigOption]s per [ServerpodCreateConfig].
  late final Map<ServerpodCreateConfig, Set<ConfigOption>> _stateValues = {};

  /// Tracked state for focused [ConfigOption] per [ServerpodCreateConfig].
  late final Map<ServerpodCreateConfig, ServerpodCreateConfigState>
  _optionStateValues = {};

  int _maxFocusedConfigIndex = 0;

  int get maxFocusedConfigIndex => _maxFocusedConfigIndex;

  bool _creatingProject = false;
  bool get creatingProject => _creatingProject;

  int _focusedConfigIndex = 0;
  int get focusedConfigIndex => _focusedConfigIndex;

  @override
  final logHistory = BoundedQueueList<Object>(1000);

  @override
  final Map<String, TrackedOperation> activeOperations = {};

  ServerpodTemplateType? get template =>
      getSelectedOptionFor<TemplateTypeOption>(
        ServerpodCreateConfig.template,
      )?.toTemplate;

  /// Updates internal state and restores the state for template config
  /// based on provided [template].
  ///
  /// Configurations that have unmet requirements based on the current state are removed.
  void _resetState(ServerpodTemplateType template) {
    configValues.clear();
    for (final config in ServerpodCreateConfig.values) {
      if (!config.templates.contains(template) || isConfigConstrained(config)) {
        _stateValues.remove(config);
        _optionStateValues.remove(config);
        continue;
      }
      configValues.add(config);
      _stateValues[config] ??= config.defaultOptions;
      _optionStateValues[config] ??= ServerpodCreateConfigState(config);
    }

    _maxFocusedConfigIndex = configValues.length - 1;

    const templateConfig = ServerpodCreateConfig.template;

    // Restore state for template config
    _stateValues[templateConfig] = {template.toConfigOption};
    final configState = ServerpodCreateConfigState(templateConfig);
    configState._focusedOptionIndex = templateConfig.options.indexOf(
      template.toConfigOption,
    );
    _optionStateValues[templateConfig] = configState;
  }

  /// Called when project creation starts.
  /// This transitions the UI to a log viewer.
  void markCreatingProject() {
    _creatingProject = true;
  }

  /// Updates the focused [ServerpodCreateConfig].
  void updateFocusedConfig(int delta) {
    _focusedConfigIndex += delta;
    if (_focusedConfigIndex > maxFocusedConfigIndex) {
      _focusedConfigIndex = 0;
    } else if (_focusedConfigIndex < 0) {
      _focusedConfigIndex = maxFocusedConfigIndex;
    }
  }

  /// True when [config] is partially locked because at least one requirement
  /// on another config is not satisfied.
  bool isConfigConstrained(ServerpodCreateConfig config) {
    return config.requirements.any(_isRequirementUnsatisfied);
  }

  /// True when [req] is not satisfied given current selections.
  bool _isRequirementUnsatisfied(ConfigRequirement req) {
    return getSelectedOptionFor(req.requiredConfig) != req.requiredConfigOption;
  }

  /// Updates the selected [ConfigOption] for the focused [ServerpodCreateConfig].
  void selectConfigOption(int delta) {
    final config = configValues[_focusedConfigIndex];
    final configState = _optionStateValues[config];
    if (configState == null) return;
    configState._updateFocusedOption(delta);
    final focusedOptionIndex = configState.focusedOptionIndex;
    final newSelection = config.options[focusedOptionIndex];

    if (config.multiSelect) {
      final selections = _stateValues[config];
      if (selections?.contains(newSelection) == true) {
        _stateValues[config] = selections!.difference({newSelection});
      } else {
        _stateValues[config] = {...?selections, newSelection};
      }
    } else {
      _stateValues[config] = {newSelection};
    }
    _evaluateRequirements();
    _updateState();
  }

  void updateSelectedOption(ServerpodCreateConfig config, ConfigOption option) {
    if (config.multiSelect) {
      final selections = _stateValues[config];
      if (selections?.contains(option) == true) {
        _stateValues[config] = selections!.difference({option});
      } else {
        _stateValues[config] = {...?selections, option};
      }
    } else {
      _stateValues[config] = {option};
    }
    _focusedConfigIndex = configValues.indexOf(config);
    final configState = _optionStateValues[config];
    configState?._focusedOptionIndex = config.options.indexOf(option);
    _evaluateRequirements();
    _updateState();
  }

  void _updateState() {
    // Reset state for current template type
    final selected = getSelectedOptionFor<TemplateTypeOption>(
      ServerpodCreateConfig.template,
    );
    if (selected == null) return;
    _resetState(selected.toTemplate);
  }

  /// Evaluates requirements defined for each [ServerpodCreateConfig].
  void _evaluateRequirements() {
    for (final config in configValues) {
      if (config.requirements.isEmpty) continue;
      for (final req in config.requirements) {
        final selectedOption = getSelectedOptionFor(req.requiredConfig);
        if (selectedOption != req.requiredConfigOption) {
          _stateValues[config] = {req.disabledOption};
          final configState = _optionStateValues[config];
          // Update the focused option index to keep UI interaction in sync
          configState?._focusedOptionIndex = config.options.indexOf(
            req.disabledOption,
          );
        }
      }
    }
  }

  /// Returns the [ServerpodCreateConfigState] for [config].
  /// This is typically used to retrieve the focused option for a [config].
  ServerpodCreateConfigState? getStateFor<T extends ConfigOption>(
    ServerpodCreateConfig<T> config,
  ) {
    return _optionStateValues[config];
  }

  /// Returns the selected [ConfigOption] for [config].
  /// For multi-select configs, use [getSelectedOptionsFor] instead.
  T? getSelectedOptionFor<T extends ConfigOption>(
    ServerpodCreateConfig<T> config,
  ) {
    final value = _stateValues[config];
    return value?.first as T?;
  }

  /// Returns all selected [ConfigOption]s for [config].
  /// Only applicable for multi-select configs.
  Set<T>? getSelectedOptionsFor<T extends ConfigOption>(
    ServerpodCreateConfig<T> config,
  ) {
    return _stateValues[config]?.cast<T>();
  }

  /// Returns true if [option] is the selected option for [config].
  bool getStatus<T extends ConfigOption>(
    ServerpodCreateConfig<T> config,
    T option,
  ) {
    final value = _stateValues[config];
    return value?.contains(option) == true;
  }

  /// Converts this state to [TemplateContext].
  TemplateContext toTemplateContext() {
    final selectedIdes = getSelectedOptionsFor(ServerpodCreateConfig.ide) ?? {};

    return TemplateContext(
      auth: getStatus(ServerpodCreateConfig.auth, BoolConfigOption.enabled),
      redis: getStatus(
        ServerpodCreateConfig.redis,
        BoolConfigOption.enabled,
      ),
      postgres: getStatus(
        ServerpodCreateConfig.database,
        DatabaseConfigOption.postgres,
      ),
      sqlite: getStatus(
        ServerpodCreateConfig.database,
        DatabaseConfigOption.sqlite,
      ),
      web: getStatus(ServerpodCreateConfig.web, BoolConfigOption.enabled),
      ides: selectedIdes.toTemplateIdes,
    );
  }
}

/// Internal state of [config] tracking the focused option.
class ServerpodCreateConfigState<T extends ServerpodCreateConfig> {
  ServerpodCreateConfigState(this.config)
    : _maxIndex = config.options.length - 1;

  final T config;
  final int _maxIndex;

  late int _focusedOptionIndex = config.multiSelect ? -1 : 0;
  int get focusedOptionIndex => _focusedOptionIndex;

  void _updateFocusedOption(int delta) {
    _focusedOptionIndex += delta;
    if (_focusedOptionIndex > _maxIndex) {
      _focusedOptionIndex = 0;
    } else if (_focusedOptionIndex < 0) {
      _focusedOptionIndex = _maxIndex;
    }
  }
}
