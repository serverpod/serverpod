# Design: Reliable Future Call Execution

## Summary

The current future call execution mechanism deletes the future call record before a server begins execution. If the server crashes or shuts down during execution, the call is permanently lost.

In distributed environments this risk increases due to:

- rolling deployments
- container restarts
- autoscaling
- node crashes

This design introduces a **claim-based execution model** using a new database table. Servers claim future calls by inserting a record into this table. The database enforces exclusivity, ensuring that only one server executes a given call. If a server crashes, the claim is removed by a cleanup job and the task becomes eligible for execution again.

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
    id: int, relation(parent=serverpod_future_call,onDelete=Cascade)

    ### Timestamp of this claim entry
    time: DateTime
    ```

### Execution Flow

#### 1. Scan for due future calls

Servers periodically query future calls that are due for execution without deletion.

    ```dart
    final entries = await FutureCallEntry.db.find(
      _internalSession,
      where: (row) => row.time <= now,
    );
    ```

#### 2. Claim future call execution

Each server attempts to write a claim for the future calls to `serverpod_future_call_claim` table.

    ```dart
    final insertedClaims = await FutureCallClaimEntry.db.insert(
      _internalSession,
      claims,
    );
    ```

Once claimed, the server executes the future calls. The claim acts as a lease lock during execution.

#### 3. On successful execution

The future calls are permanently deleted from `serverpod_future_call` and `serverpod_future_call_claim` tables.

    ```dart
    // deletion will cascade to the serverpod_future_call_claim table
    await FutureCallEntry.db.delete(_internalSession, entries);
    ```

#### 4. Crash recovery

If a server crashes, the future call and claim both remain. A cleanup job removes all pending claims on start up so that an available server may reclaim execution.

### Potential Issues

#### 1. Multiple execution

Server crashes mid execution may allow multiple executions of a future call. Developers should be encouraged to make future calls idempotent.

#### 2. Orphaned claims

Claims may accumulate if:

- Cleanup fails on startup
- A server with claim to a future call crashes in a distributed environment

A periodic maintenance job will be introduced delete claim entries that are older than 30 minutes.

## Backwards Compatibility

This implementation will maintain full backwards compatibility. Existing future calls remain compatible as logic switches to claim-based model.
