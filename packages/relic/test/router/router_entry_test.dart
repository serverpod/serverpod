// Copyright 2019 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
import 'package:relic/src/router/router_entry.dart';
import 'package:test/test.dart';

void main() {
  void testPattern(
    String pattern, {
    Map<String, Map<String, String>> match = const {},
    List<String> notMatch = const [],
  }) {
    group('RouterEntry: "$pattern"', () {
      final r = RouterEntry('GET', pattern, () => null);
      for (final e in match.entries) {
        test('Matches "${e.key}"', () {
          expect(r.match(e.key), equals(e.value));
        });
      }
      for (final v in notMatch) {
        test('NotMatch "$v"', () {
          expect(r.match(v), isNull);
        });
      }
    });
  }

  testPattern('/hello', match: {
    '/hello': {},
  }, notMatch: [
    '/not-hello',
    '/',
  ]);

  testPattern(r'/user/<user>/groups/<group|\d+>', match: {
    '/user/jonasfj/groups/42': {
      'user': 'jonasfj',
      'group': '42',
    },
    '/user/jonasfj/groups/0': {
      'user': 'jonasfj',
      'group': '0',
    },
    '/user/123/groups/101': {
      'user': '123',
      'group': '101',
    },
  }, notMatch: [
    '/user/',
    '/user/jonasfj/groups/5-3',
    '/user/jonasfj/test/groups/5',
    '/user/jonasfjtest/groups/4/',
    '/user/jonasfj/groups/',
    '/not-hello',
    '/',
  ]);

  test('non-capture regex only', () {
    expect(() => RouterEntry('GET', '/users/<user|([^]*)>/info', () {}),
        throwsA(anything));
  });
}
