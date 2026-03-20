# Design: Reliable Future Call Execution

## Summary

The current future call execution mechanism deletes the future call record before a server begins execution. If the server crashes or shuts down during execution, the call is permanently lost.

In distributed environments this risk increases due to:

- rolling deployments
- container restarts
- autoscaling
- node crashes

This design introduces a **claim-based execution model** using a new database table. Servers claim future calls by inserting a record into this table. The database enforces exclusivity, ensuring that only one server executes a given call. If a server crashes, the claim is removed by a cleanup job and the call becomes eligible for execution again.

## Proposed Solution

Introduce a `serverpod_future_call_claim` table with a unique constraint.

Execution ownership is established by inserting a row into this table. The unique constraint ensures only one server can claim a call.

The future call record is only deleted after successful execution.

### Database Schema

```yaml
### Bindings to a future call claim entry in the database.
class: FutureCallClaimEntry
table: serverpod_future_call_claim

fields:
    ### The id of the future call this claim entry is associated with
    futureCallId: int?, relation(parent=serverpod_future_call, onDelete=Cascade)

    ### Heartbeat timestamp for this claim entry.
    ### Used to detect stale claims that should be cleaned up.
    heartbeat: DateTime

indexes:
  future_call_unique_idx:
    fields: futureCallId
    unique: true
```

### Execution Flow

#### 1. Scan for due future calls

The server periodically queries future calls that are due for execution without deletion.

```dart
final entries = await FutureCallEntry.db.find(
  _internalSession,
  where: (row) => row.time <= now,
);
```

#### 2. Claim future call execution

The server attempts to claim execution of a future call by inserting a record into `serverpod_future_call_claim` table.

```dart
final claim = FutureCallClaimEntry(
  id: futureCallEntry.id,
  heartbeat: DateTime.now().toUtc(),
);

await FutureCallClaimEntry.db.insert(_internalSession, [
  claim,
], ignoreConflicts: true);
```

The server executes the future calls if the insert is successful. The claim acts as a lease lock during execution. If the insert fails due to the unique constraint, another server has already claimed the call.

#### 3. On successful execution

The future call is permanently deleted from `serverpod_future_call` and `serverpod_future_call_claim` tables.

```dart
// deletion will cascade to the serverpod_future_call_claim table
await FutureCallEntry.db.delete(_internalSession, futureCallEntry);
```

#### 4. Hearbeat Pings

Claims for future calls that are running will be updated with a heartbeat timestamp every 30 seconds to keep them alive. This will allow for the `FutureCallScanner` to also delete stale claims when it finds due future calls.
A claim will be considered stale if its heartbeat timestamp is behind by 2x the normal hearbeat interval (that is, by 1 minute).

```dart
final staleClaimThreshold = DateTime.now().toUtc().subtract(
  _heartbeatInterval * 2,
);

await FutureCallClaimEntry.db.deleteWhere(
  _internalSession,
  where: (t) => t.heartbeat < staleClaimThreshold,
);
```

This mechanism ensures that claims obtained by degraded or dead server instances are freed for available instances to re-claim.

### Potential Issues

#### 1. Multiple execution

Server crashes mid execution may allow multiple executions of a future call. Developers should be encouraged to make future calls idempotent.

#### 2. Orphaned claims

A claim becomes orphaned when a server with claim to a future call becomes unavailable before the future call execution completes.

The heartbeat mechanism ensures that orphaned claims are freed. However there will be a delay of 2x the heartbeat interval before orphaned claims can be freed for available servers to reclaim.

## Backwards Compatibility

This implementation will maintain full backwards compatibility. Existing future calls remain compatible as logic switches to claim-based model.
