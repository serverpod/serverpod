import 'dart:convert';

import 'package:serverpod/src/generated/reactive_database_call_entry.dart';
import 'package:serverpod_database/serverpod_database.dart';

import 'future_call.dart';
import '../session.dart';

/// A [FutureCall] that reacts to changes in the database.
///
/// Subclasses define a [condition] that is used as a trigger condition.
/// When matching rows are inserted, updated, or deleted, the change is
/// recorded in an outbox table. A scanner creates a [FutureCall] entry
/// to claim those events, and [invokeWithEntryId] collects and dispatches
/// them to [react].
///
/// Typically, users extend a generated per-model intermediate class
/// (e.g., `TripReactiveFutureCall`) rather than this class directly.
abstract class ReactiveFutureCall<T extends TableRow> extends FutureCall<T> {
  /// The database table this reactive call watches.
  String get tableName;

  /// The trigger condition. If null, all changes fire the trigger.
  Expression? get condition => null;

  /// Called when matching changes are detected in the outbox.
  Future<void> react(Session session, List<T> objects);

  /// Collects claimed outbox events and dispatches them to [react].
  ///
  /// Called by the execution pipeline with the [FutureCallEntry] ID that
  /// claimed the outbox events. Queries the claimed events, deserializes
  /// the row data, and calls [react] with the typed objects.
  Future<void> invokeWithEntryId(Session session, int futureCallEntryId) async {
    final entries = await ReactiveDatabaseCallEntry.db.find(
      session,
      where: (t) => t.futureCallEntryId.equals(futureCallEntryId),
    );

    if (entries.isEmpty) return;

    final objects = <dynamic>[
      for (final entry in entries) ?_deserializeRowData(session, entry.rowData),
    ];

    if (objects.isNotEmpty) {
      await react(session, objects.cast<T>());
    }
  }

  @override
  Future<void> invoke(Session session, T? object) => Future.value();

  TableRow? _deserializeRowData(Session session, String rowDataJson) {
    try {
      final jsonData = jsonDecode(rowDataJson) as Map<String, dynamic>;
      return session.serverpod.serializationManager.deserialize<TableRow>(
        jsonData,
        dataType,
      );
    } catch (_) {
      return null;
    }
  }
}
