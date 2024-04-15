import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given missing templates folder when loading templates then no templates are loaded',
      () async {
    await templates.loadAll();

    expect(templates, isEmpty);
  });
}
