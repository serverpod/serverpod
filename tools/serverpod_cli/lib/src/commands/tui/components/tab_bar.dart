import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/tui/serverpod_theme.dart';

/// A tab bar component.
class TabBar extends StatelessComponent {
  const TabBar({
    super.key,
    required this.labels,
    required this.selectedTab,
    required this.onTabChanged,
  });

  final List<String> labels;
  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  @override
  Component build(BuildContext context) {
    final tabComponents = <Component>[];
    // First spacing.
    tabComponents.add(
      _TabSpacing(
        width: 1,
        type: selectedTab == 0
            ? _TabSpacingType.shortRight
            : _TabSpacingType.full,
      ),
    );
    for (int i = 0; i < labels.length; i += 1) {
      // Tab.
      tabComponents.add(
        _Tab(
          label: labels[i],
          selected: i == selectedTab,
          onTap: () => onTabChanged(i),
        ),
      );

      // Spacing after tab.
      _TabSpacingType spacingType;
      if (i == selectedTab) {
        spacingType = _TabSpacingType.shortLeft;
      } else if (i == selectedTab - 1) {
        spacingType = _TabSpacingType.shortRight;
      } else {
        spacingType = _TabSpacingType.full;
      }
      tabComponents.add(_TabSpacing(width: 2, type: spacingType));
    }

    // Fill remaining space after last tab.
    tabComponents.add(
      Expanded(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return _TabSpacing(
              width: constraints.maxWidth.toInt(),
              type: _TabSpacingType.full,
            );
          },
        ),
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tabComponents,
    );
  }
}

class _Tab extends StatelessComponent {
  const _Tab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Component build(BuildContext context) {
    final theme = ServerpodTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: theme.brightText,
              fontWeight: selected ? FontWeight.normal : FontWeight.dim,
            ),
          ),
          Text(
            ''.padLeft(label.length, '━'),
            style: TextStyle(
              color: selected ? theme.activationKey : null,
              fontWeight: selected ? FontWeight.normal : FontWeight.dim,
            ),
          ),
        ],
      ),
    );
  }
}

enum _TabSpacingType { full, shortLeft, shortRight }

class _TabSpacing extends StatelessComponent {
  final int width;
  final _TabSpacingType type;

  const _TabSpacing({required this.width, required this.type});

  @override
  Component build(BuildContext context) {
    String underline;
    switch (type) {
      case _TabSpacingType.full:
        underline = ''.padLeft(width, '━');
        break;
      case _TabSpacingType.shortLeft:
        underline = '╺'.padRight(width, '━');
        break;
      case _TabSpacingType.shortRight:
        underline = '╸'.padLeft(width, '━');
        break;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(''.padLeft(width)),
        Text(underline, style: const TextStyle(fontWeight: FontWeight.dim)),
      ],
    );
  }
}
