import 'package:nocterm/nocterm.dart';
// ignore: implementation_imports
import 'package:nocterm/src/framework/terminal_canvas.dart';

/// Lets [child] lay out at its natural size and reports that size up the
/// tree, ignoring the parent's constraints.
///
/// Unlike [OverflowBox], which always sizes itself to the parent's
/// constraints (so the child's natural size never propagates up), this
/// widget adopts the child's reported size verbatim. Useful for components
/// like `AsciiText` whose paint extent is fixed by the source font and
/// shouldn't be clamped by an enclosing Row/Column.
class UnconstrainedBox extends SingleChildRenderObjectComponent {
  const UnconstrainedBox({super.key, super.child});

  @override
  RenderUnconstrainedBox createRenderObject(BuildContext context) =>
      RenderUnconstrainedBox();

  @override
  void updateRenderObject(
    BuildContext context,
    RenderUnconstrainedBox renderObject,
  ) {
    // Nothing to update.
  }
}

class RenderUnconstrainedBox extends RenderObject
    with RenderObjectWithChildMixin<RenderObject> {
  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! BoxParentData) {
      child.parentData = BoxParentData();
    }
  }

  @override
  void performLayout() {
    if (child == null) {
      size = Size.zero;
      return;
    }
    child!.layout(const BoxConstraints(), parentUsesSize: true);
    size = child!.size;
    (child!.parentData as BoxParentData).offset = Offset.zero;
  }

  @override
  void paint(TerminalCanvas canvas, Offset offset) {
    super.paint(canvas, offset);
    if (child != null) {
      child!.paintWithContext(canvas, offset);
    }
  }

  @override
  bool hitTestChildren(HitTestResult result, {required Offset position}) {
    return child?.hitTest(result, position: position) ?? false;
  }
}
