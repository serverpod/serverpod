import 'package:serverpod_cli/src/commands/create/tui/config.dart';
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:serverpod_tui/serverpod_tui.dart';

/// Central state for [ServerpodCreateApp] rendered by nocterm.
class CreateConfigState extends TuiState {
  CreateConfigState(this.startingTemplate) {
    form.updateSelectedOption(
      ServerpodCreateConfig.template,
      startingTemplate.toConfigOption,
    );
  }

  final ServerpodTemplateType startingTemplate;

  late final form = FormState(ServerpodCreateConfig.values);

  bool _creatingProject = false;
  bool get creatingProject => _creatingProject;

  @override
  final logHistory = BoundedQueueList<Object>(1000);

  @override
  final Map<String, TrackedOperation> activeOperations = {};

  ServerpodTemplateType get template =>
      form.getSelectedOptionFor(ServerpodCreateConfig.template)?.toTemplate ??
      startingTemplate;

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
      auth: form.isOptionSelectedForConfig(
        ServerpodCreateConfig.auth,
        BoolFormConfigOption.enabled,
      ),
      redis: form.isOptionSelectedForConfig(
        ServerpodCreateConfig.redis,
        BoolFormConfigOption.enabled,
      ),
      postgres: form.isOptionSelectedForConfig(
        ServerpodCreateConfig.database,
        DatabaseConfigOption.postgres,
      ),
      sqlite: form.isOptionSelectedForConfig(
        ServerpodCreateConfig.database,
        DatabaseConfigOption.sqlite,
      ),
      web: form.isOptionSelectedForConfig(
        ServerpodCreateConfig.web,
        BoolFormConfigOption.enabled,
      ),
      ides: selectedIdes.toTemplateIdes,
    );
  }
}
