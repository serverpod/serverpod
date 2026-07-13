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
      final canCreate =
          (state.form.hasSingleScreen || state.form.isSummary) &&
          state.canCreate;

      if (canCreate) {
        state.markCreatingProject();
        holder.markDirty();
        onCreate();
      } else {
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
                _buildHeader(theme, state),
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
                          submitButtonLabel: summaryAction,
                        ),
                ),
              ],
            ),
          ),
        ),
        _buildButtonBar(theme, state, isUpgrade: isUpgrade),
      ],
    );
  }

  Component _buildHeader(ServerpodThemeData theme, CreateConfigState state) {
    final showingSummary = state.form.isSummary;
    final creatingProject = state.creatingProject;

    final title = switch (creatingProject) {
      true => isUpgrade ? 'Upgrading project' : 'Creating project',
      false => switch (showingSummary) {
        true => 'Summary',
        false => isUpgrade ? 'Upgrade project' : 'Create new project',
      },
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
          Text(
            '💡 Click to select',
            style: TextStyle(
              color: theme.brightText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Component _buildButtonBar(
    ServerpodThemeData theme,
    CreateConfigState state, {
    required bool isUpgrade,
  }) {
    final creatingProject = state.creatingProject;
    final isFirstScreen = state.form.currentScreenIndex == 0;
    final isSummary = state.form.isSummary;
    final hasSingleScreen = state.form.hasSingleScreen;
    final createEnabled = !isSummary || state.canCreate;
    final enterButtonLabel = switch (hasSingleScreen || isSummary) {
      true => isUpgrade ? 'Upgrade Project' : 'Create Project',
      false => 'Next',
    };

    return ButtonBar(
      buttons: [
        Button(
          name: enterButtonLabel,
          activationChar: 'Enter',
          activationKeys: const [LogicalKey.enter],
          onActivate: (_) {
            if (hasSingleScreen || state.form.isSummary) {
              state.markCreatingProject();
              holder.markDirty();
              onCreate();
            } else {
              state.form.nextScreen();
              holder.markDirty();
            }
          },
          enabled:
              (hasSingleScreen ? state.canCreate : createEnabled) &&
              !creatingProject,
        ),
        if (!hasSingleScreen)
          Button(
            name: 'Back',
            activationChar: 'Esc',
            activationKeys: const [LogicalKey.escape],
            onActivate: (_) {
              state.form.previousScreen();
              holder.markDirty();
            },
            enabled: !isFirstScreen && !creatingProject,
          ),
        Button(
          name: 'Navigate',
          activationChar: '←↑↓→',
          activationKeys: const [
            LogicalKey.arrowLeft,
            LogicalKey.arrowRight,
            LogicalKey.arrowUp,
            LogicalKey.arrowDown,
          ],
          onActivate: (key) {
            switch (key) {
              case LogicalKey.arrowLeft:
                state.form.focusLeft();
                break;
              case LogicalKey.arrowRight:
                state.form.focusRight();
                break;
              case LogicalKey.arrowUp:
                if (isSummary) {
                  scrollController.scrollUp(3);
                } else {
                  state.form.focusUp();
                }
                break;
              case LogicalKey.arrowDown:
                if (isSummary) {
                  scrollController.scrollDown(3);
                } else {
                  state.form.focusDown();
                }
                break;
            }
            holder.markDirty();
          },
          enabled: !creatingProject,
        ),
        Button(
          name: 'Select',
          activationChar: 'Space',
          activationKeys: const [LogicalKey.space],
          onActivate: (_) {
            state.form.onSelect();
            holder.markDirty();
          },
          enabled: !creatingProject,
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
