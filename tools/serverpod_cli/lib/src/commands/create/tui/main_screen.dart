import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/create/tui/config.dart';
import 'package:serverpod_cli/src/commands/create/tui/state.dart';
import 'package:serverpod_cli/src/commands/create/tui/state_holder.dart';
import 'package:serverpod_cli/src/commands/create/tui/text_button.dart';
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
    final state = holder.state;
    final creatingProject = state.creatingProject;
    final showingSummary = state.isSummary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: BorderedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(theme, state),
                Expanded(
                  child: creatingProject
                      ? _buildLogView()
                      : _buildScreenContent(theme, state),
                ),
                if (!creatingProject && !showingSummary)
                  _buildScreenButtons(theme, state),
              ],
            ),
          ),
        ),
        _buildButtonBar(theme, state),
      ],
    );
  }

  FormSelectionConfig? _getCurrentConfig(CreateConfigState state) {
    final configs = state.form.configurations;
    final idx = state.currentScreenIndex;
    if (idx >= 0 && idx < configs.length) {
      return configs[idx] as FormSelectionConfig?;
    }
    return null;
  }

  Component _buildHeader(ServerpodThemeData theme, CreateConfigState state) {
    final showingSummary = state.isSummary;
    final creatingProject = state.creatingProject;
    final title = showingSummary
        ? 'Summary'
        : creatingProject
        ? 'Creating project'
        : 'Create new project';

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

  Component _buildScreenContent(
    ServerpodThemeData theme,
    CreateConfigState state,
  ) {
    if (state.isSummary) {
      return _buildSummaryScreen(theme, state);
    }

    final config = _getCurrentConfig(state);
    if (config == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: _buildConfigScreen(theme, state, config),
      ),
    );
  }

  Component _buildConfigScreen(
    ServerpodThemeData theme,
    CreateConfigState state,
    FormSelectionConfig config,
  ) {
    final focusedOptionIndex = state.form.getFocusedOptionIndexFor(config) ?? 0;

    bool isFocused(int optionIndex) {
      return !state.focusOnButton && focusedOptionIndex == optionIndex;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 1),
        Text(
          config.label,
          style: const TextStyle(
            color: Color.defaultColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 1),
        if (config.isBoolean)
          _buildBooleanOption(theme, state, config)
        else
          Wrap(
            spacing: 2,
            children: [
              for (final option in config.options.indexed)
                GestureDetector(
                  onTap: () {
                    state.form.updateSelectedOption(config, option.$2);
                    holder.markDirty();
                  },
                  child: config.multiSelect
                      ? Checkbox(
                          label: option.$2.label,
                          value: state.form.isOptionSelectedForConfig(
                            config,
                            option.$2,
                          ),
                          focused: isFocused(option.$1),
                        )
                      : RadioButton(
                          label: option.$2.label,
                          value:
                              state.form.getSelectedOptionFor(config) ==
                              option.$2,
                          focused: isFocused(option.$1),
                        ),
                ),
            ],
          ),
        const SizedBox(height: 2),
        if (config.description case final FormDescription description?)
          Text(
            description.label,
            style: const TextStyle(
              color: Color.defaultColor,
              fontWeight: FontWeight.dim,
            ),
          ),
      ],
    );
  }

  Component _buildBooleanOption(
    ServerpodThemeData theme,
    CreateConfigState state,
    FormSelectionConfig config,
  ) {
    final selectedOption =
        state.form.getSelectedOptionFor(config) as BoolFormConfigOption?;
    final isEnabled = selectedOption == BoolFormConfigOption.enabled;

    return GestureDetector(
      onTap: () {
        state.form.updateSelectedOption(
          config,
          isEnabled
              ? BoolFormConfigOption.disabled
              : BoolFormConfigOption.enabled,
        );
        holder.markDirty();
      },
      child: Checkbox(
        label: 'Enable authentication',
        value: isEnabled,
        focused: true,
      ),
    );
  }

  Component _buildSummaryScreen(
    ServerpodThemeData theme,
    CreateConfigState state,
  ) {
    final configs = state.form.configurations;

    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 1),
            for (final config in configs)
              _buildSummaryItem(theme, state, config as FormSelectionConfig),
            const SizedBox(height: 1),
            const Text(
              'Press Enter to create the project.',
              style: TextStyle(
                color: Color.defaultColor,
                fontWeight: FontWeight.dim,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Component _buildSummaryItem(
    ServerpodThemeData theme,
    CreateConfigState state,
    FormSelectionConfig config,
  ) {
    return Container(
      padding: const EdgeInsets.only(bottom: 1),
      child: Row(
        children: [
          Text(
            '${config.label}: ',
            style: const TextStyle(
              color: Color.defaultColor,
            ),
          ),
          Text(
            _getSummaryValue(state, config),
            style: const TextStyle(
              color: Color.defaultColor,
            ),
          ),
        ],
      ),
    );
  }

  String _getSummaryValue(CreateConfigState state, FormConfig config) {
    if (config is FormSelectionConfig) {
      if (config.multiSelect) {
        final options = state.form.getSelectedOptionsFor(config) ?? {};
        final names = options.map((op) => op.label).join(', ');
        return names.isEmpty ? 'None' : names;
      } else {
        final option = state.form.getSelectedOptionFor(config);
        if (config.isBoolean) {
          final enabled = option == BoolFormConfigOption.enabled;
          return enabled ? 'Enabled' : 'Disabled';
        } else {
          return option?.label ?? 'None';
        }
      }
    }

    return '';
  }

  Component _buildButtonBar(
    ServerpodThemeData theme,
    CreateConfigState state,
  ) {
    final creatingProject = state.creatingProject;
    final isFirstScreen = state.currentScreenIndex == 0;
    final isSummary = state.isSummary;
    final createEnabled = !isSummary || state.canCreate;

    return ButtonBar(
      buttons: [
        Button(
          name: isSummary ? 'Create Project' : 'Next',
          activationChar: 'Enter',
          activationKeys: const [LogicalKey.enter],
          onActivate: (_) {
            if (state.isSummary) {
              state.markCreatingProject();
              holder.markDirty();
              onCreate();
            } else {
              state.nextScreen();
              holder.markDirty();
            }
          },
          enabled: createEnabled && !creatingProject,
        ),
        Button(
          name: 'Back',
          activationChar: 'Esc',
          activationKeys: const [LogicalKey.escape],
          onActivate: (_) {
            state.previousScreen();
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
                state.focusLeft();
                break;
              case LogicalKey.arrowRight:
                state.focusRight();
                break;
              case LogicalKey.arrowUp:
                state.focusUp();
                break;
              case LogicalKey.arrowDown:
                state.focusDown();
                break;
            }
            holder.markDirty();
          },
          enabled: !isSummary && !creatingProject,
        ),
        Button(
          name: 'Select',
          activationChar: 'Space',
          activationKeys: const [LogicalKey.space],
          onActivate: (_) {
            state.onSelect();
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

  Component _buildScreenButtons(
    ServerpodThemeData theme,
    CreateConfigState state,
  ) {
    final isFirstScreen = state.currentScreenIndex == 0;
    final isSummary = state.isSummary;

    return Align(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            name: 'Back',
            activationKeys: const [LogicalKey.space],
            onActivate: (_) {
              state.previousScreen();
              holder.markDirty();
            },
            enabled: !isFirstScreen,
            focused: state.focusOnButton && state.focusedButtonIndex == 0,
          ),
          const SizedBox(width: 1),
          TextButton(
            name: 'Next',
            activationKeys: const [LogicalKey.space],
            onActivate: (_) {
              if (isSummary) {
                if (state.canCreate) {
                  state.markCreatingProject();
                  holder.markDirty();
                  onCreate();
                }
              } else {
                state.nextScreen();
                holder.markDirty();
              }
            },
            enabled: !isSummary,
            focused: state.focusOnButton && state.focusedButtonIndex == 1,
          ),
        ],
      ),
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
