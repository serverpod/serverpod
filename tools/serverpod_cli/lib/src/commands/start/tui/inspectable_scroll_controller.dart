import 'package:nocterm/nocterm.dart';

/// A [ScrollController] that keeps a reference to its attached
/// [RenderListViewport] so callers can query item geometry.
///
/// The base controller only exposes [ensureIndexVisible], which cannot
/// position an item taller than the viewport (it shows the item's scroll-space
/// start - in a reversed log list that is the visual bottom). Exposing
/// [itemOffsetAndExtent] lets callers implement their own positioning, e.g.
/// pinning a log entry's message line to the top when its stack trace expands
/// past a full screen.
class InspectableScrollController extends ScrollController {
  RenderListViewport? _viewport;

  @override
  void attach(Object renderObject) {
    super.attach(renderObject);
    if (renderObject is RenderListViewport) _viewport = renderObject;
  }

  @override
  void detach(Object renderObject) {
    if (_viewport == renderObject) _viewport = null;
    super.detach(renderObject);
  }

  /// Scroll-space offset and extent of the item at [index], or null when no
  /// viewport is attached or the item is not laid out.
  (double offset, double extent)? itemOffsetAndExtent(int index) =>
      _viewport?.getItemOffsetAndExtent(index);
}
