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

    return TemplateContext(
      template: template,
      auth: _isOptionSelected(
        ServerpodCreateConfig.auth,
        BoolFormConfigOption.enabled,
        fallback: defaults.auth,
      ),
      redis: _isOptionSelected(
        ServerpodCreateConfig.redis,
        BoolFormConfigOption.enabled,
        fallback: defaults.redis,
      ),
      postgres: _isOptionSelected(
        ServerpodCreateConfig.database,
        DatabaseConfigOption.postgres,
        fallback: defaults.postgres,
      ),
      sqlite: _isOptionSelected(
        ServerpodCreateConfig.database,
        DatabaseConfigOption.sqlite,
        fallback: defaults.sqlite,
      ),
      web: _isOptionSelected(
        ServerpodCreateConfig.web,
        BoolFormConfigOption.enabled,
        fallback: defaults.web,
      ),
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
