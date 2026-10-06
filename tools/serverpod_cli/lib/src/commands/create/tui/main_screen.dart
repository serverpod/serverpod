import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/create/tui/state.dart';
import 'package:serverpod_cli/src/commands/create/tui/state_holder.dart';
import 'package:serverpod_tui/serverpod_tui.dart';

class MainScreen extends StatelessComponent {
  const MainScreen({
    super.key,
    required this.holder,
    required this.scrollController,
    required this.logScrollController,
    required this.onCreate,
    required this.onQuit,
    required this.isUpgrade,
  });

  final CreateAppStateHolder holder;
  final ScrollController scrollController;
  final ScrollController logScrollController;
  final VoidCallback onCreate;
  final VoidCallback onQuit;
  final bool isUpgrade;

  @override
  Component build(BuildContext context) {
    final theme = ServerpodTheme.of(context);
    final state = holder.state;
    final creatingProject = state.creatingProject;
    final summaryAction = isUpgrade ? 'Upgrade' : 'Create';

    void onSubmit() {
      if (state.form.hasSingleScreen || state.form.isSummary) {
        if (!state.form.canAdvance) return;
        state.markCreatingProject();
        holder.markDirty();
        onCreate();
      } else {
        state.form.confirmFocusedOption();
        state.form.nextScreen();
        holder.markDirty();
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: BorderedBox(
            backgroundColor: Color.defaultColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(state),
                const SizedBox(height: 1),
                Expanded(
                  child: creatingProject
                      ? LogViewerWidget(
                          state: state,
                          scrollController: logScrollController,
                          keyboardScrollable: true,
                        )
                      : Form.multiScreen(
                          state: state.form,
                          scrollController: scrollController,
                          rebuild: holder.markDirty,
                          summaryDescription:
                              'Press Enter to ${summaryAction.toLowerCase()} the project.',
                          onSubmit: onSubmit,
                        ),
                ),
              ],
            ),
          ),
        ),
        _buildButtonBar(theme, state, onSubmit: onSubmit),
      ],
    );
  }

  Component _buildHeader(CreateConfigState state) {
    final form = state.form;
    final showStep = !form.isSummary && !state.creatingProject;

    final title = switch (state.creatingProject) {
      true => isUpgrade ? 'Upgrading project' : 'Creating project',
      false => isUpgrade ? 'Upgrade project' : 'Create new project',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color.defaultColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (showStep)
            Text(
              'Step ${form.currentScreenIndex + 1} of ${form.configScreenCount}',
              style: const TextStyle(
                color: Color.defaultColor,
                fontWeight: FontWeight.dim,
              ),
            ),
        ],
      ),
    );
  }

  Component _buildButtonBar(
    ServerpodThemeData theme,
    CreateConfigState state, {
    required VoidCallback onSubmit,
  }) {
    final form = state.form;
    final creatingProject = state.creatingProject;
    final isFirstScreen = form.currentScreenIndex == 0;
    final isSummary = form.isSummary;
    final hasSingleScreen = form.hasSingleScreen;
    final currentConfig = form.currentConfig;
    final isMultiSelect =
        currentConfig is FormSelectionConfig && currentConfig.multiSelect;
    final enterButtonLabel = switch (hasSingleScreen || isSummary) {
      true => isUpgrade ? 'Upgrade Project' : 'Create Project',
      false => 'Continue',
    };

    return ButtonBar(
      buttons: [
        Button(
          name: enterButtonLabel,
          activationChar: 'Enter',
          activationKeys: const [LogicalKey.enter],
          onActivate: (_) => onSubmit(),
          enabled: form.canAdvance && !creatingProject,
        ),
        if (!hasSingleScreen)
          Button(
            name: 'Back',
            activationChar: 'Esc',
            activationKeys: const [LogicalKey.escape],
            onActivate: (_) {
              form.previousScreen();
              holder.markDirty();
            },
            enabled: !isFirstScreen && !creatingProject,
          ),
        Button(
          name: 'Move',
          activationChar: '↑↓',
          activationKeys: const [LogicalKey.arrowUp, LogicalKey.arrowDown],
          onActivate: (key) {
            final up = key == LogicalKey.arrowUp;
            if (isSummary) {
              up
                  ? scrollController.scrollUp(3)
                  : scrollController.scrollDown(3);
            } else {
              up ? form.focusUp() : form.focusDown();
            }
            holder.markDirty();
          },
          enabled: !creatingProject,
        ),
        Button(
          name: isMultiSelect ? 'Toggle' : 'Select',
          activationChar: 'Space',
          activationKeys: const [LogicalKey.space],
          onActivate: (_) {
            form.onSelect();
            holder.markDirty();
          },
          enabled: !isSummary && !creatingProject,
        ),
        Button(
          name: 'Quit',
          activationChar: 'Q',
          activationKeys: const [LogicalKey.keyQ],
          onActivate: (_) => onQuit(),
        ),
      ],
    );
  }
}
