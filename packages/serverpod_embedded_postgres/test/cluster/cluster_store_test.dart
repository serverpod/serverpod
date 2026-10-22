import 'dart:io';

import 'package:serverpod_embedded_postgres/src/cluster/cluster_store.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a password containing a line break, '
    'when the superuser password is set, '
    'then it is rejected without echoing the password',
    () async {
      var cluster = ClusterStore(
        installDir: Directory('unused'),
        dataDir: Directory('unused'),
      );

      await expectLater(
        cluster.setSuperuserPassword(
          username: 'postgres',
          password: 'top\nsecret',
          timeout: const Duration(seconds: 1),
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.toString(),
            'toString',
            allOf(contains('line breaks'), isNot(contains('secret'))),
          ),
        ),
      );
    },
  );
}
