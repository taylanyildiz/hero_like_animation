import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

typedef ItemBuilder = Widget Function(BuildContext context, int index);

class GridExpandableView extends StatefulWidget {
  const GridExpandableView({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
  }) : super(key: key);

  final int itemCount;
  final ItemBuilder itemBuilder;

  @override
  State<GridExpandableView> createState() => _Grid();
}

class _Grid extends State<GridExpandableView> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double get value => _animation.value;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    super.initState();
  }

  void _onTapLayout() {}

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translate(lerpDouble(0.0, 20.0, value)),
          child: Stack(
            children: [
              Opacity(
                opacity: 1 - value,
                child: child,
              ),
            ],
          ),
        );
      },
      child: _buildGrid,
    );
  }

  Widget get _buildGrid {
    return GridView.builder(
      shrinkWrap: false,
      padding: const EdgeInsets.only(left: 70.0, top: 20.0),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200.0,
        mainAxisExtent: 280.0,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
      ),
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        return _ExpandableCard(
          child: widget.itemBuilder.call(context, index),
          animation: _animation,
          onPress: (value) async {
            if (value) {
              await _controller.forward();
            } else {
              await _controller.reverse();
            }
          },
        );
      },
    );
  }
}

class _ExpandableCard extends StatefulWidget {
  const _ExpandableCard({
    Key? key,
    required this.child,
    required this.onPress,
    required this.animation,
  }) : super(key: key);

  final Widget child;
  final FutureOr Function(bool open) onPress;
  final Animation<double> animation;

  @override
  State<_ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<_ExpandableCard> {
  OverlayEntry? overlayEntry;
  final LayerLink _link = LayerLink();
  final GlobalKey _key = GlobalKey();

  double get value => widget.animation.value;

  @override
  void initState() {
    WidgetsBinding.instance?.scheduleFrameCallback((timeStamp) {
      _createOverlay();
    });
    super.initState();
  }

  void _createOverlay() {
    overlayEntry = OverlayEntry(builder: _builderOverlay);
  }

  Widget _builderOverlay(BuildContext context) {
    RenderObject? object = _key.currentContext?.findRenderObject();
    assert(object != null);
    RenderBox renderBox = object as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    print(offset);
    double width = size.width;
    double height = size.height;
    return LayoutBuilder(
      builder: ((context, constraints) {
        return AnimatedBuilder(
            animation: widget.animation,
            builder: (context, child) {
              var _offet = getOffset(offset, size);
              return Stack(
                children: [
                  GestureDetector(
                    child: GestureDetector(
                      onTap: _onClose,
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  Positioned(
                    height: height + (height + 10) * value,
                    width: width + (width + 10) * value,
                    left: offset.dx + _offet.dx,
                    top: offset.dy + _offet.dy,
                    child: widget.child,
                  ),
                ],
              );
            });
      }),
    );
  }

  Offset getOffset(Offset position, Size size) {
    double dx = position.dx;
    double dy = position.dy;
    double d1 = 0.0;
    double d2 = 0.0;
    if (dx <= 200) {
      d1 = 0.0;
    }
    if (dy <= 204.0) {
      d2 = 0.0;
    }
    if (dy > 204.0) {
      d2 = -(size.height + 10) * value;
    }
    if (dx > 75.0) {
      d1 = -(size.width + 10) * value;
    }
    return Offset(d1, d2);
  }

  void _onClose() async {
    await widget.onPress.call(false);
    overlayEntry?.remove();
  }

  void _onTap() async {
    Overlay.of(context)?.insert(overlayEntry!);
    await widget.onPress.call(true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: KeyedSubtree(
        key: _key,
        child: widget.child,
      ),
    );
  }
}
