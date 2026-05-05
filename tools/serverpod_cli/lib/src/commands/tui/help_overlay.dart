import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/tui/serverpod_theme.dart';

typedef HelpOverlayBindings = List<(String, List<(String, String)>)>;

/// Help overlay showing all keybindings.
class HelpOverlay extends StatefulComponent {
  const HelpOverlay({super.key, this.bindings});

  final HelpOverlayBindings? bindings;

  @override
  State<StatefulComponent> createState() => _HelpOverlayState();
}

class _HelpOverlayState extends State<HelpOverlay> {
  static const _bindings = [
    (
      'Navigation',
      [
        ('↑ / k', 'Scroll up'),
        ('↓ / j / Enter', 'Scroll down'),
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
      'Tabs',
      [
        ('Tab', 'Switch tab'),
        ('1', 'Log Messages'),
        ('2', 'Raw Output'),
      ],
    ),
    (
      'Actions',
      [
        ('R', 'Hot Reload'),
        ('M', 'Create Migration'),
        ('A', 'Apply Migration'),
        ('Q', 'Quit'),
      ],
    ),
  ];

  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    final st = ServerpodTheme.of(context);

    final theme = TuiTheme.of(context);
    final effectiveBindings = component.bindings ?? _bindings;

    return Center(
      child: SizedBox(
        width: 56,
        height: 29,
        child: Container(
          decoration: BoxDecoration(
            color: theme.surface,
            border: BoxBorder.all(
              style: BoxBorderStyle.rounded,
              color: st.activeTab,
            ),
            title: BorderTitle(
              text: 'Help',
              style: TextStyle(color: st.activeTab),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: ListView(
                      controller: _scrollController,
                      children: [
                        for (final (section, bindings)
                            in effectiveBindings) ...[
                          Text(
                            section,
                            style: TextStyle(
                              color: st.activeTab,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          for (final (key, desc) in bindings)
                            Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  child: Text(
                                    '  $key',
                                    style: TextStyle(
                                      color: theme.onSurface,
                                      fontWeight: FontWeight.dim,
                                    ),
                                  ),
                                ),
                                Text(
                                  desc,
                                  style: TextStyle(color: theme.onSurface),
                                ),
                              ],
                            ),
                          const SizedBox(height: 1),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'Press H or Esc to close',
                  style: TextStyle(
                    color: theme.onSurface,
                    fontWeight: FontWeight.dim,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
