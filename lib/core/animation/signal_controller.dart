import 'package:flutter/foundation.dart';

/// Shared source of truth for the scroll-linked signal line and bird.
///
/// Sections register their content-space Y position ([setAnchor]); the
/// controller converts scroll offsets into a bird screen position that
/// travels through those anchors. Listeners (line + bird) rebuild only
/// when values actually change.
class SignalController extends ChangeNotifier {
  final List<double> _anchors = <double>[];

  double _scrollOffset = 0;
  double _maxScroll = 1;

  List<double> get anchors => List.unmodifiable(_anchors);

  double get scrollOffset => _scrollOffset;
  double get maxScroll => _maxScroll;

  double get progress =>
      _maxScroll <= 0 ? 0 : (_scrollOffset / _maxScroll).clamp(0.0, 1.0);

  void setAnchor(int index, double contentY) {
    while (_anchors.length <= index) {
      _anchors.add(0);
    }
    if ((_anchors[index] - contentY).abs() > 0.5) {
      _anchors[index] = contentY;
      notifyListeners();
    }
  }

  /// Coalesced scroll updates: only notify when the offset moved enough
  /// to matter (sub-pixel scroll events are ignored).
  void updateScroll(double offset, double maxScroll) {
    final clampedMax = maxScroll > 0 ? maxScroll : 1;
    if ((offset - _scrollOffset).abs() > 0.4 ||
        (clampedMax - _maxScroll).abs() > 0.5) {
      _scrollOffset = offset;
      _maxScroll = clampedMax.toDouble();
      notifyListeners();
    }
  }

  /// The bird's Y position in viewport coordinates, travelling through
  /// the registered section anchors as the visitor scrolls.
  double birdScreenY(double viewportHeight) {
    if (_anchors.length < 2) return viewportHeight * 0.22;
    final first = _anchors.first;
    final last = _anchors.last;
    if (last <= first) return viewportHeight * 0.22;
    final target = _scrollOffset + viewportHeight * 0.45;
    final t = ((target - first) / (last - first)).clamp(0.0, 1.0);
    return first + (last - first) * t - _scrollOffset;
  }

  /// True while the bird is between two anchor points (used to pause
  /// near meaningful sections).
  bool get isAtAnchor {
    if (_anchors.length < 2) return false;
    final y = birdScreenY(600);
    for (final a in _anchors) {
      if ((a - _scrollOffset - y).abs() < 8) return true;
    }
    return false;
  }

  @override
  void dispose() {
    _anchors.clear();
    super.dispose();
  }
}
