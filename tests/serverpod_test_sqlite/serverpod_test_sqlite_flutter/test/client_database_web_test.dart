@TestOn('browser')
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_database/serverpod_database.dart'
    show ClientDatabaseSession;
import 'package:serverpod_test_sqlite_client/serverpod_test_sqlite_client.dart';

/// A minimal app backed by a client-side database, standing in for a real one.
///
/// It opens the database while the first frame is already on screen - the same
/// shape as an app that shows a splash screen until its local data is ready.
class _CounterApp extends StatefulWidget {
  const _CounterApp({required this.databasePath, super.key});

  final String databasePath;

  @override
  State<_CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<_CounterApp> {
  ClientDatabaseSession? _session;
  List<SimpleData> _entries = const [];
  Object? _error;

  @override
  void initState() {
    super.initState();
    _openDatabase();
  }

  @override
  void dispose() {
    _session?.close();
    super.dispose();
  }

  Future<void> _openDatabase() async {
    try {
      /// The server is never reached: these tests only exercise the client-side
      /// database, which needs no connection.
      var session = await Client('http://localhost:8081/').createSession(
        widget.databasePath,
        isDebugMode: true,
      );
      var entries = await SimpleData.db.find(session);
      if (!mounted) return;
      setState(() {
        _session = session;
        _entries = entries;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
    }
  }

  Future<void> addEntry(int number) async {
    var session = _session!;
    await SimpleData.db.insertRow(session, SimpleData(num: number));
    var entries = await SimpleData.db.find(session);
    if (!mounted) return;
    setState(() => _entries = entries);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: switch ((_error, _session)) {
          (var error?, _) => Text('error: $error'),
          (_, null) => const Text('opening database'),
          _ => ListView(
            children: [
              Text('entries: ${_entries.length}'),
              for (var entry in _entries) Text('entry ${entry.num}'),
            ],
          ),
        },
      ),
    );
  }
}

void main() {
  testWidgets(
    'Given a Flutter web app with a client-side database, '
    'when it starts, '
    'then the database is opened, migrated and persists data across restarts',
    (tester) async {
      // Web databases are named, not file paths; the browser profile is new for
      // every run, so a name unique to this test is enough.
      var databasePath = 'client_database_web_test.db';

      await tester.runAsync(() async {
        var appKey = GlobalKey<_CounterAppState>();

        await tester.pumpWidget(
          _CounterApp(databasePath: databasePath, key: appKey),
        );

        // The app is up before the database is, exactly as a real one would be.
        expect(find.text('opening database'), findsOneWidget);

        // Opening runs the client migrations and, because isDebugMode is set,
        // verifies the resulting schema. Reaching an empty table proves both.
        await _pumpUntilFound(tester, find.text('entries: 0'));

        await appKey.currentState!.addEntry(42);
        await _pumpUntilFound(tester, find.text('entries: 1'));
        expect(find.text('entry 42'), findsOneWidget);

        // Tear the app down and start it again against the same database, the
        // way a page reload would.
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();

        await tester.pumpWidget(
          _CounterApp(databasePath: databasePath, key: GlobalKey()),
        );
        await _pumpUntilFound(tester, find.text('entries: 1'));
        expect(find.text('entry 42'), findsOneWidget);
      });
    },
  );
}

/// Pumps frames until [finder] matches, yielding to the event loop in between.
///
/// [WidgetTester.pumpAndSettle] cannot be used here: the database runs in a web
/// worker, and its replies only arrive on the real event loop that
/// [WidgetTester.runAsync] provides.
Future<void> _pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  var deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    await tester.pump();
    if (finder.evaluate().isNotEmpty) return;
    await Future<void>.delayed(const Duration(milliseconds: 25));
  }
  // Surface what the app is showing instead - an open failure renders as text.
  var shown = find
      .byType(Text)
      .evaluate()
      .map((e) => (e.widget as Text).data)
      .join(' | ');
  fail('Timed out waiting for $finder. On screen: $shown');
}
