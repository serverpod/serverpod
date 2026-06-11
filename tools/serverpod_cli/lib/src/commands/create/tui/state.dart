import 'package:serverpod_cli/src/commands/create/tui/config.dart';
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:serverpod_tui/serverpod_tui.dart';

/// A non-functional [FormConfig] that is used to reset
/// all focused options.
class _VoidFormConfig implements FormConfig {
  @override
  FormDescription? get description => null;

  @override
  String get label => '';

  @override
  List<FormRequirement<FormConfigOption>> get requirements => [];
}

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

  bool _focusOnButton = false;
  int _focusedButtonIndex = 0;

  bool get focusOnButton => _focusOnButton;
  int get focusedButtonIndex => _focusedButtonIndex;

  void _unfocusOptions() {
    // Trick to unfocus all options is to request a config that is unknown.
    form.requestFocus(_VoidFormConfig());
  }

  void focusBackButton() {
    _unfocusOptions();
    _focusOnButton = true;
    _focusedButtonIndex = 0;
  }

  void focusNextButton() {
    _unfocusOptions();
    _focusOnButton = true;
    _focusedButtonIndex = 1;
  }

  void focusDown() {
    if (!_focusOnButton) {
      if (isSummary || _currentScreenIndex > 0) {
        focusBackButton();
      } else if (!isSummary) {
        focusNextButton();
      }
    }
  }

  void focusUp() {
    if (_focusOnButton) {
      _focusOnButton = false;
      if (_currentScreenIndex < form.configurations.length) {
        final config = form.configurations[_currentScreenIndex];
        form.requestFocus(config);
      }
    }
  }

  void focusRight() {
    if (_focusOnButton) {
      if (_focusedButtonIndex == 0 && !isSummary) {
        focusNextButton();
      }
    } else if (_currentScreenIndex < form.configurations.length) {
      final config = form.configurations[_currentScreenIndex];
      form.requestFocus(config);
      form.updateFocusedConfigOption(1);
    }
  }

  void focusLeft() {
    if (_focusOnButton) {
      if (_focusedButtonIndex == 1 && _currentScreenIndex > 0) {
        focusBackButton();
      }
    } else if (_currentScreenIndex < form.configurations.length) {
      final config = form.configurations[_currentScreenIndex];
      form.requestFocus(config);
      form.updateFocusedConfigOption(-1);
    }
  }

  /// Current screen index (0 = first config screen, [configScreenCount] = summary).
  int get currentScreenIndex => _currentScreenIndex;

  /// Number of config screens visible in the form (not counting summary).
  int get configScreenCount => form.configurations.length;

  /// Whether the current screen is the summary screen.
  bool get isSummary => _currentScreenIndex >= configScreenCount;

  /// Total number of screens (config screens + summary).
  int get totalScreenCount => configScreenCount + 1;

  void onSelect() {
    if (_focusOnButton) {
      switch (_focusedButtonIndex) {
        case 0:
          previousScreen();
          break;
        case 1:
          nextScreen();
          break;
        default:
      }
    } else {
      form.selectConfigOption();
    }
  }

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

  /// Focus form config for the current screen.
  void _updateFormFocus() {
    _focusOnButton = false;
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
    _focusOnButton = false;
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

    final webapp = _isOptionSelected(
      ServerpodCreateConfig.webserver,
      WebServerConfigOption.appOnly,
      fallback: defaults.webapp,
    );

    final appAndWebsite = _isOptionSelected(
      ServerpodCreateConfig.webserver,
      WebServerConfigOption.appAndWebsite,
      fallback: defaults.website,
    );

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
      webapp: webapp || appAndWebsite,
      website: appAndWebsite,
      ides: selectedIdes.toTemplateIdes,
    );
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
