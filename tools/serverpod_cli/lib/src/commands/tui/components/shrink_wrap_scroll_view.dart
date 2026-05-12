import 'package:nocterm/nocterm.dart';

/// Scrolls when bounded, shrink-wraps when not.
///
/// Must sit inside a [Column] whose vertical extent is bounded - under
/// unbounded constraints it can't scroll and degrades to plain shrink-wrap.
class ShrinkWrapScrollView extends StatelessComponent {
  const ShrinkWrapScrollView({
    super.key,
    required this.child,
    this.controller,
  });

  final Component child;
  final ScrollController? controller;

  @override
  Component build(BuildContext context) {
    return Flexible(
      child: SingleChildScrollView(
        controller: controller,
        child: child,
      ),
    );
  }
}
