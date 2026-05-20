import 'dart:math' as math;
import 'package:nocterm/nocterm.dart';
// ignore: implementation_imports
import 'package:nocterm/src/framework/terminal_canvas.dart';

/// Creates a wrap layout.
/// By default, the wrap layout is horizontal.
class Wrap extends RenderObjectComponent {
  const Wrap({
    super.key,
    this.direction = Axis.horizontal,
    this.spacing = 0,
    this.runSpacing = 1,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.children = const [],
  });

  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;
  final double runSpacing;
  final List<Component> children;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderWrap(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      spacing: spacing,
      runSpacing: runSpacing,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderWrap renderObject) {
    renderObject
      ..direction = direction
      ..spacing = spacing
      ..runSpacing = runSpacing
      ..mainAxisAlignment = mainAxisAlignment
      ..crossAxisAlignment = crossAxisAlignment;
  }

  @override
  MultiChildRenderObjectElement createElement() =>
      MultiChildRenderObjectElement(this);
}

/// Render object for wrap layouts.
class RenderWrap extends RenderObject
    with ContainerRenderObjectMixin<RenderObject> {
  RenderWrap({
    required Axis direction,
    required double spacing,
    required double runSpacing,
    required MainAxisAlignment mainAxisAlignment,
    required CrossAxisAlignment crossAxisAlignment,
  }) : _direction = direction,
       _spacing = spacing,
       _runSpacing = runSpacing,
       _mainAxisAlignment = mainAxisAlignment,
       _crossAxisAlignment = crossAxisAlignment;

  Axis _direction;
  Axis get direction => _direction;
  set direction(Axis value) {
    if (_direction == value) return;
    _direction = value;
    markNeedsLayout();
  }

  double _spacing;
  double get spacing => _spacing;
  set spacing(double value) {
    if (_spacing == value) return;
    _spacing = value;
    markNeedsLayout();
  }

  double _runSpacing;
  double get runSpacing => _runSpacing;
  set runSpacing(double value) {
    if (_runSpacing == value) return;
    _runSpacing = value;
    markNeedsLayout();
  }

  MainAxisAlignment _mainAxisAlignment;
  MainAxisAlignment get mainAxisAlignment => _mainAxisAlignment;
  set mainAxisAlignment(MainAxisAlignment value) {
    if (_mainAxisAlignment == value) return;
    _mainAxisAlignment = value;
    markNeedsLayout();
  }

  CrossAxisAlignment _crossAxisAlignment;
  CrossAxisAlignment get crossAxisAlignment => _crossAxisAlignment;
  set crossAxisAlignment(CrossAxisAlignment value) {
    if (_crossAxisAlignment == value) return;
    _crossAxisAlignment = value;
    markNeedsLayout();
  }

  double _getMainAxisExtent(Size size) {
    return direction == Axis.horizontal ? size.width : size.height;
  }

  double _getCrossAxisExtent(Size size) {
    return direction == Axis.horizontal ? size.height : size.width;
  }

  Size _getSize(double mainAxisExtent, double crossAxisExtent) {
    return direction == Axis.horizontal
        ? Size(mainAxisExtent, crossAxisExtent)
        : Size(crossAxisExtent, mainAxisExtent);
  }

  BoxConstraints _getChildConstraints(BoxConstraints constraints) {
    if (direction == Axis.horizontal) {
      return BoxConstraints(
        minWidth: 0,
        maxWidth: constraints.maxWidth,
        minHeight: 0,
        maxHeight: constraints.maxHeight,
      );
    } else {
      return BoxConstraints(
        minWidth: 0,
        maxWidth: constraints.maxWidth,
        minHeight: 0,
        maxHeight: constraints.maxHeight,
      );
    }
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! FlexParentData) {
      child.parentData = FlexParentData();
    }
  }

  @override
  void performLayout() {
    final double maxMainAxisExtent = direction == Axis.horizontal
        ? constraints.maxWidth
        : constraints.maxHeight;

    final bool isBounded = maxMainAxisExtent.isFinite;

    final runs = <_WrapRun>[];

    _WrapRun currentRun = _WrapRun();

    for (final child in children) {
      child.layout(
        _getChildConstraints(constraints),
        parentUsesSize: true,
      );

      final childMainExtent = _getMainAxisExtent(child.size);
      final childCrossExtent = _getCrossAxisExtent(child.size);

      final double projectedExtent = currentRun.children.isEmpty
          ? childMainExtent
          : currentRun.mainAxisExtent + spacing + childMainExtent;

      final bool shouldWrap =
          isBounded &&
          currentRun.children.isNotEmpty &&
          projectedExtent > maxMainAxisExtent;

      if (shouldWrap) {
        runs.add(currentRun);
        currentRun = _WrapRun();
      }

      if (currentRun.children.isNotEmpty) {
        currentRun.mainAxisExtent += spacing;
      }

      currentRun.children.add(child);
      currentRun.mainAxisExtent += childMainExtent;
      currentRun.crossAxisExtent = math.max(
        currentRun.crossAxisExtent,
        childCrossExtent,
      );
    }

    if (currentRun.children.isNotEmpty) {
      runs.add(currentRun);
    }

    double containerMainAxisExtent = 0;
    double containerCrossAxisExtent = 0;

    for (int i = 0; i < runs.length; i++) {
      final run = runs[i];

      containerMainAxisExtent = math.max(
        containerMainAxisExtent,
        run.mainAxisExtent,
      );

      containerCrossAxisExtent += run.crossAxisExtent;

      if (i < runs.length - 1) {
        containerCrossAxisExtent += runSpacing;
      }
    }

    final Size calculatedSize = _getSize(
      containerMainAxisExtent,
      containerCrossAxisExtent,
    );

    size = constraints.constrain(calculatedSize);

    double runCrossOffset = 0;

    for (final run in runs) {
      final double availableMainAxisExtent = direction == Axis.horizontal
          ? size.width
          : size.height;

      final double freeSpace = math.max(
        0,
        availableMainAxisExtent - run.mainAxisExtent,
      );

      double childMainOffset = 0;
      double betweenSpace = spacing;

      switch (mainAxisAlignment) {
        case MainAxisAlignment.start:
          break;

        case MainAxisAlignment.end:
          childMainOffset = freeSpace;
          break;

        case MainAxisAlignment.center:
          childMainOffset = freeSpace / 2;
          break;

        case MainAxisAlignment.spaceBetween:
          if (run.children.length > 1) {
            betweenSpace = spacing + (freeSpace / (run.children.length - 1));
          }
          break;

        case MainAxisAlignment.spaceAround:
          if (run.children.isNotEmpty) {
            final extraSpace = freeSpace / run.children.length;
            betweenSpace = spacing + extraSpace;
            childMainOffset = extraSpace / 2;
          }
          break;

        case MainAxisAlignment.spaceEvenly:
          if (run.children.isNotEmpty) {
            final extraSpace = freeSpace / (run.children.length + 1);

            betweenSpace = spacing + extraSpace;
            childMainOffset = extraSpace;
          }
          break;
      }

      for (final child in run.children) {
        final childParentData = child.parentData as FlexParentData;

        final childCrossExtent = _getCrossAxisExtent(child.size);

        double childCrossOffset = 0;

        switch (crossAxisAlignment) {
          case CrossAxisAlignment.start:
            childCrossOffset = 0;
            break;

          case CrossAxisAlignment.center:
            childCrossOffset = (run.crossAxisExtent - childCrossExtent) / 2;
            break;

          case CrossAxisAlignment.end:
            childCrossOffset = run.crossAxisExtent - childCrossExtent;
            break;

          case CrossAxisAlignment.stretch:
          case CrossAxisAlignment.baseline:
            childCrossOffset = 0;
            break;
        }

        childParentData.offset = direction == Axis.horizontal
            ? Offset(
                childMainOffset,
                runCrossOffset + childCrossOffset,
              )
            : Offset(
                runCrossOffset + childCrossOffset,
                childMainOffset,
              );

        childMainOffset += _getMainAxisExtent(child.size) + betweenSpace;
      }

      runCrossOffset += run.crossAxisExtent + runSpacing;
    }
  }

  @override
  void paint(TerminalCanvas canvas, Offset offset) {
    super.paint(canvas, offset);

    for (final child in children) {
      final childParentData = child.parentData as FlexParentData;

      child.paintWithContext(
        canvas,
        offset + childParentData.offset,
      );
    }
  }

  @override
  bool hitTestChildren(
    HitTestResult result, {
    required Offset position,
  }) {
    for (final child in children.reversed) {
      final childParentData = child.parentData as FlexParentData;

      final childPosition = position - childParentData.offset;

      if (child.hitTest(result, position: childPosition)) {
        return true;
      }
    }

    return false;
  }
}

class _WrapRun {
  final List<RenderObject> children = [];

  double mainAxisExtent = 0;
  double crossAxisExtent = 0;
}
