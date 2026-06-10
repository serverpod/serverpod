import 'package:serverpod_cli/src/commands/create/tui/config.dart';
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:serverpod_tui/serverpod_tui.dart';

/// Central state for [ServerpodCreateApp] rendered by nocterm.
class CreateConfigState extends TuiState {
  CreateConfigState(
    this.startingTemplate, {
    this.configs = ServerpodCreateConfig.values,
    TemplateContext? defaults,
    this.requireIde = false,
  }) : defaults = defaults ?? TemplateContext() {
    if (configs.contains(ServerpodCreateConfig.template)) {
      form.updateSelectedOption(
        ServerpodCreateConfig.template,
        startingTemplate.toConfigOption,
      );
    }
  }

  final ServerpodTemplateType startingTemplate;

  /// The configurations exposed in the form.
  final List<ServerpodCreateConfig> configs;

  /// Fallback values for configurations not exposed in the form.
  /// Configurations hidden by an unsatisfied [FormRequirement] are
  /// not affected and resolve from the form as usual.
  final TemplateContext defaults;

  /// Whether at least one IDE must be selected
  /// before the project can be created.
  final bool requireIde;

  late final form = FormState(configs);

  bool _creatingProject = false;
  bool get creatingProject => _creatingProject;

  int _currentScreenIndex = 0;

  /// Current screen index (0 = first config screen, [configScreenCount] = summary).
  int get currentScreenIndex => _currentScreenIndex;

  /// Number of config screens visible in the form (not counting summary).
  int get configScreenCount => form.configurations.length;

  /// Whether the current screen is the summary screen.
  bool get isSummary => _currentScreenIndex >= configScreenCount;

  /// Total number of screens (config screens + summary).
  int get totalScreenCount => configScreenCount + 1;

  /// Advances to the next screen.
  void nextScreen() {
    if (_currentScreenIndex < configScreenCount) {
      _currentScreenIndex++;
      _updateFormFocus();
    }
  }

  /// Goes back to the previous screen.
  void previousScreen() {
    if (_currentScreenIndex > 0) {
      _currentScreenIndex--;
      _updateFormFocus();
    }
  }

  void _updateFormFocus() {
    if (_currentScreenIndex < form.configurations.length) {
      final config = form.configurations[_currentScreenIndex];
      form.requestFocus(config);
      final currentFocus = form.getFocusedOptionIndexFor(config) ?? 0;
      if (currentFocus > 0) {
        form.updateFocusedConfigOption(-currentFocus);
      }
    }
  }

  /// Resets to the first screen.
  void resetScreens() {
    _currentScreenIndex = 0;
  }

  @override
  final logHistory = BoundedQueueList<Object>(1000);

  @override
  final Map<String, TrackedOperation> activeOperations = {};

  ServerpodTemplateType get template =>
      form.getSelectedOptionFor(ServerpodCreateConfig.template)?.toTemplate ??
      startingTemplate;

  /// True when all required selections are made
  /// and the project can be created.
  bool get canCreate {
    if (!requireIde) return true;
    final selectedIdes = form.getSelectedOptionsFor(ServerpodCreateConfig.ide);
    return selectedIdes != null && selectedIdes.isNotEmpty;
  }

  /// Called when project creation starts.
  /// This transitions the UI to a log viewer.
  void markCreatingProject() {
    _creatingProject = true;
  }

  /// Converts this state to [TemplateContext].
  TemplateContext toTemplateContext() {
    final selectedIdes =
        form.getSelectedOptionsFor(ServerpodCreateConfig.ide) ?? {};

    final webOption = form.getSelectedOptionFor(ServerpodCreateConfig.web);

    return TemplateContext(
      template: template,
      auth: _isOptionSelected(
        ServerpodCreateConfig.auth,
        BoolFormConfigOption.enabled,
        fallback: defaults.auth,
      ),
      redis: _isOptionSelected(
        ServerpodCreateConfig.database,
        DatabaseConfigOption.redis,
        fallback: defaults.redis,
      ),
      postgres: _isOptionSelected(
        ServerpodCreateConfig.database,
        DatabaseConfigOption.database,
        fallback: defaults.postgres,
      ),
      sqlite: false,
      web: _getWebOption(webOption, fallback: defaults.web),
      ides: selectedIdes.toTemplateIdes,
    );
  }

  /// Returns the web bool from the given [WebConfigOption] option,
  /// or [fallback] if no option is selected or config is not exposed.
  bool _getWebOption(WebConfigOption? option, {required bool fallback}) {
    if (!configs.contains(ServerpodCreateConfig.web)) return fallback;
    return option == WebConfigOption.appAndWebsite;
  }

  /// Returns whether [option] is selected for [config] in the form,
  /// or [fallback] if [config] is not exposed in the form at all.
  bool _isOptionSelected<T extends FormConfigOption>(
    ServerpodCreateConfig<T> config,
    T option, {
    required bool fallback,
  }) {
    if (!configs.contains(config)) return fallback;
    return form.isOptionSelectedForConfig(config, option);
  }
}
