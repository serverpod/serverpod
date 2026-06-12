import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/create/tui/state_holder.dart';
import 'package:serverpod_tui/serverpod_tui.dart';

class MainScreen extends StatelessComponent {
  const MainScreen({
    super.key,
    required this.name,
    required this.holder,
    required this.scrollController,
    required this.logScrollController,
    required this.onCreate,
    required this.onQuit,
  });

  final String name;
  final CreateAppStateHolder holder;
  final ScrollController scrollController;
  final ScrollController logScrollController;
  final VoidCallback onCreate;
  final VoidCallback onQuit;

  @override
  Component build(BuildContext context) {
    final theme = ServerpodTheme.of(context);
    final creatingProject = holder.state.creatingProject;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: BorderedBox(
            child: Column(
              children: [
                _buildHeader(theme),
                Expanded(
                  child: creatingProject ? _buildLogView() : _buildForm(),
                ),
              ],
            ),
          ),
        ),
        _buildButtonBar(theme),
      ],
    );
  }

  Component _buildHeader(ServerpodThemeData theme) {
    final creatingProject = holder.state.creatingProject;
    final title = creatingProject
        ? 'Creating the "$name" project'
        : 'Configure the "$name" project';

    return Container(
      padding: const EdgeInsets.only(bottom: 1),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color.defaultColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Component _buildForm() {
    final state = holder.state;
    return Form(
      state: state.form,
      scrollController: scrollController,
      rebuild: holder.markDirty,
    );
  }

  Component _buildButtonBar(ServerpodThemeData theme) {
    final state = holder.state;
    final form = state.form;
    final creatingProject = state.creatingProject;
    return ButtonBar(
      buttons: [
        Button(
          name: 'Create Project',
          activationChar: 'Enter',
          enabled: !creatingProject && state.canCreate,
          activationKeys: const [LogicalKey.enter],
          onActivate: (_) {
            state.markCreatingProject();
            holder.markDirty();
            onCreate.call();
          },
        ),
        Button(
          name: 'Navigate',
          activationChar: '←↑↓→',
          enabled: !creatingProject,
          activationKeys: const [
            LogicalKey.arrowUp,
            LogicalKey.arrowDown,
            LogicalKey.arrowLeft,
            LogicalKey.arrowRight,
          ],
          onActivate: (key) {
            switch (key) {
              case LogicalKey.arrowLeft:
                form.updateFocusedConfigOption(-1);
                break;
              case LogicalKey.arrowRight:
                form.updateFocusedConfigOption(1);
                break;
              case LogicalKey.arrowUp:
                form.updateFocusedConfig(-1);
                if (form.focusedConfigIndex == form.maxFocusedConfigIndex) {
                  scrollController.scrollToEnd();
                } else {
                  scrollController.scrollUp(3);
                }
                break;
              case LogicalKey.arrowDown:
                form.updateFocusedConfig(1);
                if (form.focusedConfigIndex == 0) {
                  scrollController.scrollToStart();
                } else {
                  scrollController.scrollDown(3);
                }
                break;
            }
            holder.markDirty();
          },
        ),
        Button(
          name: 'Select',
          activationChar: 'Space',
          enabled: !creatingProject,
          activationKeys: const [LogicalKey.space],
          onActivate: (_) {
            form.selectConfigOption();
            holder.markDirty();
          },
        ),
        Button(
          name: 'Quit',
          activationChar: 'Q',
          activationKeys: const [LogicalKey.keyQ],
          onActivate: (_) {
            onQuit.call();
          },
        ),
        if (state.canCreate)
          const Tip('Click to select')
        else
          const Tip('Select at least one IDE'),
      ],
    );
  }

  Component _buildLogView() {
    return LogViewerWidget(
      state: holder.state,
      scrollController: logScrollController,
      keyboardScrollable: true,
    );
  }
}
