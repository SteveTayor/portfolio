import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/content/projects.dart';

void main() {
  test('every shown project has a unique id, screenshots and a case study', () {
    final ids = Projects.shown.map((p) => p.id).toSet();
    expect(ids.length, Projects.shown.length);
    for (final p in Projects.shown) {
      expect(p.images.isNotEmpty, isTrue);
      expect(p.summary.isNotEmpty, isTrue);
      expect(Projects.byId(p.id).id, p.id);
    }
  });

  test('unknown ids fall back to the first project', () {
    expect(Projects.byId('missing').id, Projects.shown.first.id);
  });

  test('next wraps around to the first project', () {
    expect(Projects.next(Projects.shown.last).id, Projects.shown.first.id);
  });
}
