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

  /// Tracked state for selected [ConfigOption] per [ServerpodCreateConfig].
  late final Map<ServerpodCreateConfig, ConfigOption> _stateValues = {};

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

  /// Resets internal state and restores the state for template config
  /// based on provided [template].
  void _resetState(ServerpodTemplateType template) {
    configValues.clear();
    _stateValues.clear();
    _optionStateValues.clear();
    for (final config in ServerpodCreateConfig.values) {
      if (!config.templates.contains(template)) continue;
      configValues.add(config);
      _stateValues[config] = config.defaultOption;
      _optionStateValues[config] = ServerpodCreateConfigState(config);
    }

    _maxFocusedConfigIndex = configValues.length - 1;

    const templateConfig = ServerpodCreateConfig.template;

    // Restore state for template config
    _stateValues[templateConfig] = template.toConfigOption;
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
    _snapFocusedOptionIfNeeded();
  }

  /// True when [option] cannot be chosen for [config] because a
  /// [ServerpodCreateConfig.requirements] clause is not satisfied.
  bool isOptionConstrained(
    ServerpodCreateConfig config,
    ConfigOption option,
  ) {
    for (final req in config.requirements) {
      if (_isRequirementUnsatisfied(req)) {
        return option != req.disabledOption;
      }
    }
    return false;
  }

  /// True when [config] is partially locked because at least one requirement
  /// on another config is not satisfied.
  bool isConfigConstrained(ServerpodCreateConfig config) {
    return config.requirements.any(_isRequirementUnsatisfied);
  }

  void _snapFocusedOptionIfNeeded() {
    final config = configValues[_focusedConfigIndex];
    final configState = _optionStateValues[config];
    if (configState == null) return;
    final option = config.options[configState.focusedOptionIndex];
    if (!isOptionConstrained(config, option)) return;
    for (var i = 0; i < config.options.length; i++) {
      final o = config.options[i];
      if (!isOptionConstrained(config, o)) {
        configState._focusedOptionIndex = i;
        return;
      }
    }
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
    _stateValues[config] = newSelection;
    _evaluateRequirements();

    // Recreate states for new selected template type
    if (_focusedConfigIndex == 0) {
      final selected = getSelectedOptionFor<TemplateTypeOption>(
        ServerpodCreateConfig.template,
      );
      if (selected == null) return;
      _resetState(selected.toTemplate);
    }
  }

  /// Evaluates requirements defined for each [ServerpodCreateConfig].
  void _evaluateRequirements() {
    for (final config in configValues) {
      if (config.requirements.isEmpty) continue;
      for (final req in config.requirements) {
        final selectedOption = getSelectedOptionFor(req.requiredConfig);
        if (selectedOption != req.requiredConfigOption) {
          _stateValues[config] = req.disabledOption;
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
  T? getSelectedOptionFor<T extends ConfigOption>(
    ServerpodCreateConfig<T> config,
  ) {
    return _stateValues[config] as T?;
  }

  /// Returns true if [option] is the selected option for [config].
  bool getStatus<T extends ConfigOption>(
    ServerpodCreateConfig<T> config,
    T option,
  ) {
    return _stateValues[config] == option;
  }

  /// Converts this state to [TemplateContext].
  TemplateContext toTemplateContext() {
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
    );
  }
}

/// Internal state of [config] tracking the focused option.
class ServerpodCreateConfigState<T extends ServerpodCreateConfig> {
  ServerpodCreateConfigState(this.config)
    : _maxIndex = config.options.length - 1;

  final T config;
  final int _maxIndex;

  int _focusedOptionIndex = 0;
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
