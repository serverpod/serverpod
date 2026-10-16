import 'package:flutter/material.dart';

/// Shows [child] when [expanded] is `true`, growing into place and fading in,
/// so that the widgets below are pushed down smoothly. Collapsing reverses the
/// transition.
class ExpandableSection extends StatelessWidget {
  /// Whether [child] is shown.
  final bool expanded;

  /// The content shown when [expanded] is `true`.
  final Widget child;

  /// Creates an [ExpandableSection] widget.
  const ExpandableSection({
    required this.expanded,
    required this.child,
    super.key,
  });

  /// The duration of the expand and collapse transitions.
  static const duration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (child, animation) => SizeTransition(
        sizeFactor: animation,
        alignment: AlignmentDirectional.topStart,
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: expanded
          ? KeyedSubtree(key: const ValueKey(true), child: child)
          : const SizedBox(key: ValueKey(false), width: double.infinity),
    );
  }
}
