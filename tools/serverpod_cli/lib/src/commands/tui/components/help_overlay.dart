import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/tui/components/shrink_wrap_scroll_view.dart';
import 'package:serverpod_cli/src/commands/tui/serverpod_theme.dart';

typedef HelpOverlayBindings = List<(String, List<(String, String)>)>;

/// Width reserved for the activation-key column in the help body.
const _keyColumnWidth = 24.0;

/// Help overlay showing all keybindings. Sizes to its content; scrolls if
/// content exceeds the available terminal height.
class HelpOverlay extends StatefulComponent {
  const HelpOverlay({super.key, this.bindings, this.controller});

  final HelpOverlayBindings? bindings;
  final ScrollController? controller;

  @override
  State<StatefulComponent> createState() => _HelpOverlayState();
}

class _HelpOverlayState extends State<HelpOverlay> {
  static const _defaultBindings = [
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
        ('Tab / →', 'Next tab'),
        ('←', 'Previous tab'),
        ('1', 'Log Messages'),
        ('2', 'Raw server output'),
      ],
    ),
    (
      'Actions',
      [
        ('R / Shift+R', 'Hot reload / restart'),
        ('M / Shift+M', 'Create migration (⇧ = force)'),
        ('P / Shift+P', 'Repair migration (⇧ = force)'),
        ('A', 'Apply migrations'),
        ('Ctrl+C', 'Copy selection, or quit'),
        ('Q', 'Quit'),
      ],
    ),
  ];

  ScrollController? _ownedController;

  ScrollController get _effectiveController =>
      component.controller ?? (_ownedController ??= ScrollController());

  @override
  void dispose() {
    _ownedController?.dispose();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    final st = ServerpodTheme.of(context);
    final theme = TuiTheme.of(context);
    final effectiveBindings = component.bindings ?? _defaultBindings;
    final scrollController = _effectiveController;

    // Outer Padding bounds the panel to (screen - 4) on each axis so
    // SingleChildScrollView has finite extent to clamp against and scroll
    // within when content overflows.
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: theme.surface,
            border: BoxBorder.all(
              style: BoxBorderStyle.rounded,
              color: st.primary,
            ),
            title: BorderTitle(
              text: 'Help',
              style: TextStyle(color: st.primary),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShrinkWrapScrollView(
                controller: scrollController,
                thumbVisibility: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final (section, items) in effectiveBindings) ...[
                      Text(
                        section,
                        style: TextStyle(
                          color: st.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      for (final (key, desc) in items)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: _keyColumnWidth,
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
    );
  }
}
