import 'package:nocterm/nocterm.dart';

import 'serverpod_theme.dart';

/// Help overlay showing all keybindings.
class HelpOverlay extends StatelessComponent {
  const HelpOverlay({super.key});

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
      'View',
      [
        ('x', 'Expand/collapse operations'),
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

  @override
  Component build(BuildContext context) {
    final st = ServerpodTheme.of(context);

    final theme = TuiTheme.of(context);

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
                for (final (section, bindings) in _bindings) ...[
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
                        Text(desc, style: TextStyle(color: theme.onSurface)),
                      ],
                    ),
                  const SizedBox(height: 1),
                ],
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
