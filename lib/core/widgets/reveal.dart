import 'package:flutter/material.dart';

/// Fades and lifts its child the first time it scrolls into view.
/// Plays once, never repeats, and shows instantly when motion is reduced.
class Reveal extends StatefulWidget {
  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.dy = 0.04,
  });

  final Widget child;
  final Duration delay;
  final double dy;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );
  late final Animation<double> _curve = _c.drive(
    CurveTween(curve: Curves.easeOutCubic),
  );
  ScrollPosition? _position;
  double _viewport = 800;
  bool _done = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewport = MediaQuery.sizeOf(context).height;
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
      _done = true;
      _c.value = 1;
      return;
    }
    final next = Scrollable.maybeOf(context)?.position;
    if (!identical(next, _position)) {
      _position?.removeListener(_check);
      _position = next;
      _position?.addListener(_check);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (_done || !mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    if (top < _viewport * 0.92) {
      _done = true;
      _position?.removeListener(_check);
      Future<void>.delayed(widget.delay, () {
        if (mounted) _c.forward();
      });
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_check);
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _curve,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, widget.dy),
          end: Offset.zero,
        ).animate(_curve),
        child: widget.child,
      ),
    );
  }
}
