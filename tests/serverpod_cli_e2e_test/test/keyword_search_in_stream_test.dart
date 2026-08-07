import 'dart:async';

import 'package:serverpod_cli_e2e_test/src/keyword_search_in_stream.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a stream search that receives duplicate matches while settling, '
    'when waiting for the next match, '
    'then it waits for a new stream event.',
    () async {
      final streamSearch = KeywordSearchInStream(
        keywords: ['complete'],
        timeout: const Duration(seconds: 2),
      );
      addTearDown(streamSearch.cancel);

      streamSearch.onData('complete');
      final firstMatch = streamSearch.keywordFound;
      await Future<void>.delayed(const Duration(milliseconds: 50));
      streamSearch.onData('complete');
      await expectLater(firstMatch, completion(isTrue));

      var nextMatchCompleted = false;
      final nextMatch = streamSearch.keywordFound.whenComplete(
        () => nextMatchCompleted = true,
      );

      await Future<void>.delayed(const Duration(milliseconds: 350));
      expect(nextMatchCompleted, isFalse);

      streamSearch.onData('complete');
      await expectLater(nextMatch, completion(isTrue));
    },
  );
}
