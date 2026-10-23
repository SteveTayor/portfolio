import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/content/projects.dart';

void main() {
  test('every project has a unique id and a case study', () {
    final ids = Projects.all.map((p) => p.id).toSet();
    expect(ids.length, Projects.all.length);
    for (final p in Projects.all) {
      expect(p.summary.isNotEmpty, isTrue);
      expect(Projects.byId(p.id).id, p.id);
    }
  });

  test('unknown ids fall back to the first project', () {
    expect(Projects.byId('missing').id, Projects.all.first.id);
  });
}
