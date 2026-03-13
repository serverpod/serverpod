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
    futureCallId: int?, relation(parent=serverpod_future_call,onDelete=Cascade)

    ### Timestamp of this claim entry
    time: DateTime

    ### The id of the server where the claim was created.
    serverId: String
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
  futureCallId: futureCallEntry.id,
  serverId: _serverId,
  time: DateTime.now().toUtc(),
);
await FutureCallClaimEntry.db.insertRow(_internalSession, claim);
```

The server executes the future calls if the insert is successful. The claim acts as a lease lock during execution. If the insert fails due to the unique constraint, another server has already claimed the call.

#### 3. On successful execution

The future call is permanently deleted from `serverpod_future_call` and `serverpod_future_call_claim` tables.

```dart
// deletion will cascade to the serverpod_future_call_claim table
await FutureCallEntry.db.delete(_internalSession, futureCallEntry);
```

#### 4. Crash recovery

If a server crashes, the future calls and claims remain. A cleanup job removes all pending claims created by that server on start up so that the claimed future calls become eligible for execution again.

### Potential Issues

#### 1. Multiple execution

Server crashes mid execution may allow multiple executions of a future call. Developers should be encouraged to make future calls idempotent.

#### 2. Orphaned claims

Claims may accumulate if:

- Cleanup fails on startup
- A server with claim to a future call becomes unavailable in a distributed environment

A periodic maintenance job will be introduced delete claim entries that are older than a configured TTL. Developers will also be able to configure how often this maintenance job runs.

## Configurations

Two new configurations will be introduced:

- **futureCall.claimCleanupInterval**: Configures how often to run the future call claim cleanup job. Defaults to 30 minutes.
- **futureCall.claimTTL**: Configures how long to keep future call claims before they become eligible for cleanup. Defaults to 10 minutes.

## Backwards Compatibility

This implementation will maintain full backwards compatibility. Existing future calls remain compatible as logic switches to claim-based model.
