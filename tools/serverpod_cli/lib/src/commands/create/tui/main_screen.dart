import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/create/tui/config.dart';
import 'package:serverpod_cli/src/commands/create/tui/state_holder.dart';
import 'package:serverpod_cli/src/commands/tui/components.dart';
import 'package:serverpod_cli/src/commands/tui/help_overlay.dart';
import 'package:serverpod_cli/src/commands/tui/serverpod_theme.dart';

class MainScreen extends StatelessComponent {
  const MainScreen({
    super.key,
    required this.name,
    required this.holder,
    required this.scrollController,
    required this.logScrollController,
    required this.onCreate,
    required this.onQuit,
    required this.onToggleHelp,
  });

  final String name;
  final CreateAppStateHolder holder;
  final ScrollController scrollController;
  final ScrollController logScrollController;
  final VoidCallback onCreate;
  final VoidCallback onQuit;
  final VoidCallback onToggleHelp;

  static const _helpBindings = [
    (
      'Navigation',
      [
        ('k', 'Scroll up'),
        ('j', 'Scroll down'),
        ('Shift+↑', 'Scroll up ¼ screen'),
        ('Shift+↓', 'Scroll down ¼ screen'),
        ('u / Ctrl+u', 'Scroll up ½ screen'),
        ('d / Ctrl+d', 'Scroll down ½ screen'),
        ('PgUp / b / Backspace', 'Scroll up one screen'),
        ('PgDn / Space / f', 'Scroll down one screen'),
        ('Home / g', 'Go to start'),
        ('End / G', 'Go to end'),
      ],
    ),
    (
      'Actions',
      [
        ('Enter', 'Create Project'),
        ('↑↓', 'Navigate Options'),
        ('←→', 'Select Option'),
        ('Q', 'Quit'),
      ],
    ),
  ];

  @override
  Component build(BuildContext context) {
    final theme = ServerpodTheme.of(context);
    final state = holder.state;
    final creatingProject = state.creatingProject;

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              BorderedBox(
                color: theme.activeTab,
                child: Column(
                  children: [
                    _buildHeader(theme),
                    Expanded(
                      child: creatingProject
                          ? _buildLogView()
                          : _buildForm(theme),
                    ),
                  ],
                ),
              ),
              if (state.showHelp) const HelpOverlay(bindings: _helpBindings),
            ],
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
            style: TextStyle(
              color: theme.activeTab,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Component _buildForm(ServerpodThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Scrollbar(
        controller: scrollController,
        thumbVisibility: true,
        child: ListView(
          controller: scrollController,
          children: [_buildConfigurations(theme)],
        ),
      ),
    );
  }

  Component _buildConfigurations(ServerpodThemeData theme) {
    final state = holder.state;
    final configurations = state.configValues;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final config in configurations.indexed) ...[
          _buildConfiguration(
            theme,
            config.$2,
            config.$1 == state.focusedConfigIndex,
          ),
          const SizedBox(height: 1),
        ],
      ],
    );
  }

  Component _buildConfiguration(
    ServerpodThemeData theme,
    ServerpodCreateConfig config,
    bool focused,
  ) {
    final state = holder.state;
    final selectedOption = state.getSelectedOptionFor(config);

    bool isOptionFocused(int optionIndex) {
      return focused &&
          state.getStateFor(config)?.focusedOptionIndex == optionIndex;
    }

    final titleColor = !state.isConfigConstrained(config)
        ? selectedOption?.isUserDisabled ?? false
              ? Colors.white
              : theme.success
        : theme.failure;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          config.label,
          style: TextStyle(
            color: titleColor,
            fontWeight: focused ? FontWeight.bold : FontWeight.dim,
          ),
        ),
        Row(
          children: [
            for (final option in config.options.indexed) ...[
              _buildConfigurationOption(
                theme,
                option.$2,
                selected: selectedOption == option.$2,
                focused: isOptionFocused(option.$1),
                enabled: !state.isOptionConstrained(config, option.$2),
              ),
              const SizedBox(width: 2),
            ],
          ],
        ),
      ],
    );
  }

  Component _buildConfigurationOption(
    ServerpodThemeData theme,
    ConfigOption option, {
    required bool selected,
    required bool focused,
    required bool enabled,
  }) {
    return RadioButton(
      label: option.label,
      focused: focused,
      value: selected,
      enabled: enabled,
    );
  }

  Component _buildButtonBar(ServerpodThemeData theme) {
    final state = holder.state;
    final creatingProject = state.creatingProject;
    return ButtonBar(
      buttons: [
        Button(
          name: 'Create Project',
          activationChar: 'Enter',
          enabled: !creatingProject,
          activationKeys: const [LogicalKey.enter],
          onActivate: (_) {
            state.markCreatingProject();
            holder.markDirty();
            onCreate.call();
          },
        ),
        Button(
          name: 'Navigate Options',
          activationChar: '↑↓',
          enabled: !creatingProject,
          activationKeys: const [LogicalKey.arrowUp, LogicalKey.arrowDown],
          onActivate: (key) {
            switch (key) {
              case LogicalKey.arrowUp:
                state.updateFocusedConfig(-1);
                if (state.focusedConfigIndex == state.maxFocusedConfigIndex) {
                  scrollController.scrollToEnd();
                } else {
                  scrollController.scrollUp(3);
                }
                break;
              case LogicalKey.arrowDown:
                state.updateFocusedConfig(1);
                if (state.focusedConfigIndex == 0) {
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
          name: 'Select Option',
          activationChar: '←→',
          enabled: !creatingProject,
          activationKeys: const [LogicalKey.arrowLeft, LogicalKey.arrowRight],
          onActivate: (key) {
            switch (key) {
              case LogicalKey.arrowLeft:
                state.selectConfigOption(-1);
                break;
              case LogicalKey.arrowRight:
                state.selectConfigOption(1);
                break;
            }
            holder.markDirty();
          },
        ),
        Button(
          name: 'Help',
          activationChar: 'H',
          activationKeys: const [LogicalKey.keyH],
          onActivate: (_) {
            onToggleHelp.call();
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
      ],
    );
  }

  Component _buildLogView() {
    return LogViewerWidget(
      state: holder.state,
      scrollController: logScrollController,
    );
  }
}

extension on ConfigOption {
  bool get isUserDisabled {
    return (this is BoolConfigOption && this == BoolConfigOption.disabled) ||
        (this is DatabaseConfigOption && this == DatabaseConfigOption.none);
  }
}
