import 'package:nocterm/nocterm.dart';

/// Scrolls when bounded, shrink-wraps when not.
///
/// Must sit inside a [Column] whose vertical extent is bounded.
/// Under unbounded constraints it can't scroll and degrades to plain shrink-wrap.
/// Pass [thumbVisibility] to wrap the scrollable in a [Scrollbar] with the thumb shown.
class ShrinkWrapScrollView extends StatelessComponent {
  const ShrinkWrapScrollView({
    super.key,
    required this.child,
    this.controller,
    this.thumbVisibility = false,
  });

  final Component child;
  final ScrollController? controller;
  final bool thumbVisibility;

  @override
  Component build(BuildContext context) {
    Component scrollable = SingleChildScrollView(
      controller: controller,
      child: child,
    );
    if (thumbVisibility) {
      scrollable = Scrollbar(
        controller: controller,
        thumbVisibility: true,
        child: scrollable,
      );
    }
    return Flexible(child: scrollable);
  }
}
