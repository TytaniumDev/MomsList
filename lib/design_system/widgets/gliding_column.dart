import 'package:flutter/rendering.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moms_list/design_system/tokens/app_motion.dart';

/// A full-width column whose children glide to their new places when they
/// move, such as an item sliding down to Got it when it's checked off and
/// back up when it's put back. A new child fades in where it lands; a
/// removed one is gone at once while the rest close the gap.
///
/// Give every child a key that stays with it wherever it goes, such as
/// `ValueKey(item.id)`: a child with the same key is the same child.
///
/// It's cheap to animate: each child is its own layer (like a [ListView]
/// row), and gliding only moves and fades those layers, with no layout or
/// rebuild on each frame. It lays every child out, so put it in a scroll
/// view and keep it to lists of up to a few hundred rows.
///
/// With Reduce Motion on, a moved child fades in at its new place instead
/// of gliding. With animations off, changes are instant.
class GlidingColumn extends StatefulWidget {
  const new({required this.children, super.key});

  final List<Widget> children;

  @override
  State<GlidingColumn> createState() => _GlidingColumnState();
}

class _GlidingColumnState extends State<GlidingColumn>
    with SingleTickerProviderStateMixin {
  // Starts finished: nothing animates on the first build.
  late final _controller = AnimationController(vsync: this, value: 1);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget.children.every((child) => child.key != null),
      'Every child of a GlidingColumn needs a key.',
    );
    _controller.duration = AppMotion.durationOf(context, AppMotion.standard);
    return _GlidingColumnLayout(
      controller: _controller,
      glides: AppMotion.allowsMovementOf(context),
      children: [
        for (final child in widget.children)
          RepaintBoundary(key: child.key, child: child),
      ],
    );
  }
}

class _GlidingColumnLayout extends MultiChildRenderObjectWidget {
  const new({
    required this.controller,
    required this.glides,
    required super.children,
  });

  final AnimationController controller;
  final bool glides;

  @override
  _RenderGlidingColumn createRenderObject(BuildContext context) =>
      _RenderGlidingColumn(controller, glides: glides);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderGlidingColumn renderObject,
  ) {
    renderObject
      ..glides = glides
      ..childrenMayHaveMoved();
  }
}

/// Where a child of [_RenderGlidingColumn] is, and where it's gliding from.
class _GlidingParentData extends ContainerBoxParentData<RenderBox> {
  /// Not laid out yet: it fades in when it first appears.
  bool isNew = true;

  /// How far from [offset] the child is drawn when the glide starts. It
  /// shrinks to nothing as the glide runs.
  Offset glideFrom = Offset.zero;

  /// The child's opacity when the glide starts. It grows to 1.
  double fadeFrom = 1;

  final LayerHandle<OpacityLayer> _opacityLayer = LayerHandle();
}

/// Lays children out top to bottom at full width, and draws them gliding
/// from where they were to where they are now. See [GlidingColumn].
class _RenderGlidingColumn extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _GlidingParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _GlidingParentData> {
  new(this.controller, {required this.glides});

  /// Runs the glide. It belongs to the [GlidingColumn]'s state, which
  /// outlives this render object.
  final AnimationController controller;

  /// Whether moved children glide, or only fade in at their new place.
  bool glides;

  /// Set when the children may have changed, so the next layout animates
  /// whatever moved. Other layouts, such as the screen turning, don't.
  bool _mayHaveMoved = false;
  bool _hasLaidOut = false;

  void childrenMayHaveMoved() {
    _mayHaveMoved = true;
    markNeedsLayout();
  }

  /// How far the glide has come, from 0 to 1, eased.
  double get _progress => AppMotion.enter.transform(controller.value);

  Offset _shiftOf(_GlidingParentData data) => data.glideFrom * (1 - _progress);

  double _opacityOf(_GlidingParentData data) =>
      data.fadeFrom + (1 - data.fadeFrom) * _progress;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _GlidingParentData) {
      child.parentData = _GlidingParentData();
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    controller.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    controller.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void dropChild(RenderObject child) {
    (child.parentData! as _GlidingParentData)._opacityLayer.layer = null;
    super.dropChild(child);
  }

  @override
  void dispose() {
    visitChildren((child) {
      (child.parentData! as _GlidingParentData)._opacityLayer.layer = null;
    });
    super.dispose();
  }

  @override
  void performLayout() {
    final width = constraints.maxWidth;
    final childConstraints = BoxConstraints.tightFor(width: width);
    final placed = <(RenderBox, Offset)>[];
    var changed = false;
    var y = 0.0;
    var child = firstChild;
    while (child != null) {
      child.layout(childConstraints, parentUsesSize: true);
      final data = child.parentData! as _GlidingParentData;
      final offset = Offset(0, y);
      changed = changed || data.isNew || data.offset != offset;
      placed.add((child, offset));
      y += child.size.height;
      child = data.nextSibling;
    }
    size = constraints.constrain(Size(width, y));

    final animate = changed && _mayHaveMoved && _hasLaidOut;
    for (final (child, offset) in placed) {
      final data = child.parentData! as _GlidingParentData;
      if (animate) {
        _startFrom(data, offset);
      } else if (changed) {
        // Laid out again for another reason, such as a new screen width:
        // settle straight away.
        data
          ..glideFrom = Offset.zero
          ..fadeFrom = 1;
      }
      data
        ..isNew = false
        ..offset = offset;
    }
    _mayHaveMoved = false;
    _hasLaidOut = true;
    if (animate) controller.forward(from: 0);
  }

  /// Sets where [data]'s child glides or fades from to reach [offset],
  /// carrying on smoothly from wherever it's drawn right now.
  void _startFrom(_GlidingParentData data, Offset offset) {
    final moved = data.offset != offset;
    if (data.isNew || (moved && !glides)) {
      data
        ..glideFrom = Offset.zero
        ..fadeFrom = 0;
      return;
    }
    data
      ..glideFrom = glides ? data.offset + _shiftOf(data) - offset : Offset.zero
      ..fadeFrom = _opacityOf(data);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final children = getChildrenAsList();
    if (!controller.isCompleted) {
      // The furthest traveller goes on top, so it slides over the rest.
      children.sort((a, b) => _travel(a).compareTo(_travel(b)));
    }
    for (final child in children) {
      final data = child.parentData! as _GlidingParentData;
      final position = offset + data.offset + _shiftOf(data);
      final alpha = (_opacityOf(data) * 255).round();
      if (alpha >= 255) {
        data._opacityLayer.layer = null;
        context.paintChild(child, position);
      } else {
        data._opacityLayer.layer = context.pushOpacity(
          position,
          alpha,
          (context, offset) => context.paintChild(child, offset),
          oldLayer: data._opacityLayer.layer,
        );
      }
    }
  }

  double _travel(RenderBox child) =>
      _shiftOf(child.parentData! as _GlidingParentData).distance;

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    var child = lastChild;
    while (child != null) {
      final data = child.parentData! as _GlidingParentData;
      final current = child;
      final hit = result.addWithPaintOffset(
        offset: data.offset + _shiftOf(data),
        position: position,
        hitTest: (result, transformed) =>
            current.hitTest(result, position: transformed),
      );
      if (hit) return true;
      child = data.previousSibling;
    }
    return false;
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    final data = child.parentData! as _GlidingParentData;
    final shifted = data.offset + _shiftOf(data);
    transform.multiply(Matrix4.translationValues(shifted.dx, shifted.dy, 0));
  }
}
