// Vendored from tuid (https://github.com/AstroNvim/tuid)
// SPDX-License-Identifier: BSD-3-Clause
// Shimmer adapted from Vide CLI (https://github.com/Norbert515/vide_cli)
import 'dart:math' as math;

import 'package:nocterm/nocterm.dart';
// ignore: implementation_imports
import 'package:nocterm/src/framework/terminal_canvas.dart';

/// A widget that applies an animated shimmer effect to its child.
///
/// Creates a diagonal highlight that sweeps across the child periodically.
class Shimmer extends StatefulComponent {
  const Shimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
    this.angle = 0.5,
    this.highlightWidth = 3,
  });

  final Component child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;
  final double angle;
  final int highlightWidth;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: component.duration,
      vsync: this,
    );
    _animation = CurveTween(curve: Curves.easeInOut).animate(_controller);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return _ShimmerRenderWidget(
      animation: _animation,
      baseColor: component.baseColor,
      highlightColor: component.highlightColor,
      angle: component.angle,
      highlightWidth: component.highlightWidth,
      child: component.child,
    );
  }
}

class _ShimmerRenderWidget extends SingleChildRenderObjectComponent {
  const _ShimmerRenderWidget({
    required this.animation,
    this.baseColor,
    this.highlightColor,
    required this.angle,
    required this.highlightWidth,
    required Component child,
  }) : super(child: child);

  final Animation<double> animation;
  final Color? baseColor;
  final Color? highlightColor;
  final double angle;
  final int highlightWidth;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderShimmer(
      animation: animation,
      baseColor: baseColor,
      highlightColor: highlightColor,
      angle: angle,
      highlightWidth: highlightWidth,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderShimmer renderObject) {
    renderObject
      ..animation = animation
      ..baseColor = baseColor
      ..highlightColor = highlightColor
      ..angle = angle
      ..highlightWidth = highlightWidth;
  }
}

class _RenderShimmer extends RenderObject
    with RenderObjectWithChildMixin<RenderObject> {
  _RenderShimmer({
    required Animation<double> animation,
    Color? baseColor,
    Color? highlightColor,
    required double angle,
    required int highlightWidth,
  }) : _animation = animation,
       _baseColor = baseColor,
       _highlightColor = highlightColor,
       _angle = angle,
       _highlightWidth = highlightWidth {
    _animation.addListener(markNeedsPaint);
  }

  Animation<double> _animation;
  set animation(Animation<double> value) {
    if (_animation == value) return;
    _animation.removeListener(markNeedsPaint);
    _animation = value;
    _animation.addListener(markNeedsPaint);
    markNeedsPaint();
  }

  Color? _baseColor;
  set baseColor(Color? value) {
    if (_baseColor == value) return;
    _baseColor = value;
    markNeedsPaint();
  }

  Color? _highlightColor;
  set highlightColor(Color? value) {
    if (_highlightColor == value) return;
    _highlightColor = value;
    markNeedsPaint();
  }

  double _angle;
  set angle(double value) {
    if (_angle == value) return;
    _angle = value;
    markNeedsPaint();
  }

  int _highlightWidth;
  set highlightWidth(int value) {
    if (_highlightWidth == value) return;
    _highlightWidth = value;
    markNeedsPaint();
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! BoxParentData) {
      child.parentData = BoxParentData();
    }
  }

  // Cached child paint result - only repainted on layout, not every frame
  Buffer? _childBuffer;

  @override
  void dispose() {
    _animation.removeListener(markNeedsPaint);
    super.dispose();
  }

  @override
  void performLayout() {
    _childBuffer = null; // Invalidate cache on layout
    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
      size = child!.size;
    } else {
      size = constraints.constrain(Size.zero);
    }
  }

  void _ensureChildPainted(TerminalCanvas canvas, Offset offset) {
    final width = size.width.toInt();
    final height = size.height.toInt();
    if (_childBuffer != null &&
        _childBuffer!.width == width &&
        _childBuffer!.height == height) {
      return;
    }
    _childBuffer = Buffer(width, height);
    final tempCanvas = TerminalCanvas(
      _childBuffer!,
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    );
    child!.paintWithContext(tempCanvas, Offset.zero);
  }

  @override
  void paint(TerminalCanvas canvas, Offset offset) {
    super.paint(canvas, offset);
    if (child == null) return;

    final width = size.width.toInt();
    final height = size.height.toInt();

    if (width <= 0 || height <= 0) {
      child!.paintWithContext(canvas, offset);
      return;
    }

    _ensureChildPainted(canvas, offset);
    final childBuf = _childBuffer!;

    final totalDiagonal = width + height * _angle;
    final progress = _animation.value;
    final shimmerCenter =
        -_highlightWidth + progress * (totalDiagonal + _highlightWidth * 2);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final cell = childBuf.getCell(x, y);

        if (cell.char == ' ' && cell.style.backgroundColor == null) {
          continue;
        }

        final cellDiagonalPos = x + y * _angle;
        final distFromShimmer = (cellDiagonalPos - shimmerCenter).abs();

        Color? newColor = cell.style.color;

        if (distFromShimmer < _highlightWidth) {
          final intensity = 1.0 - (distFromShimmer / _highlightWidth);
          final easedIntensity = math.sin(intensity * math.pi / 2);
          final highlightColor = _highlightColor ?? Colors.white;
          final baseCol = cell.style.color ?? _baseColor ?? Colors.white;
          newColor = Color.lerp(baseCol, highlightColor, easedIntensity);
        }

        canvas.drawText(
          Offset(offset.dx + x, offset.dy + y),
          cell.char,
          style: newColor != cell.style.color
              ? TextStyle(
                  color: newColor,
                  backgroundColor: cell.style.backgroundColor,
                  fontWeight: cell.style.fontWeight,
                  fontStyle: cell.style.fontStyle,
                  decoration: cell.style.decoration,
                  reverse: cell.style.reverse,
                )
              : cell.style,
        );
      }
    }
  }

  @override
  bool hitTestChildren(HitTestResult result, {required Offset position}) {
    if (child != null) {
      return child!.hitTest(result, position: position);
    }
    return false;
  }
}
