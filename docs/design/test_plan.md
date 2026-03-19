# Test Plan

There is a working implementation of the claim-based model for reliable future calls. Reference `reliable_future_calls.md` for the design details. Reference `FutureCallManager` and `FutureCallScanner` for the implementation.

The goal is to add new tests for the claim feature. Add the tests to `tests/serverpod_test_server/test_integration/future_calls/future_call_claim_model_test.dart`.

Here are all of the expected test groups:

1. Given FutureCallManager with scheduled FutureCall that is due
when running scheduled FutureCalls
then a claim is inserted for the FutureCall
then the FutureCall is executed
then the claim is deleted

2. Given FutureCallManager with scheduled FutureCall that is due with existing claim in the database for the FutureCall
when running scheduled FutureCalls
then the FutureCall is not executed
then the claim is not deleted

3. Given FutureCallManager with scheduled FutureCall that is due with existing stale claim in the database for the FutureCall
when running scheduled FutureCalls
then the FutureCall is executed
then the claim is deleted

4. Given FutureCallManager with scheduled long running FutureCall that is due
when running scheduled FutureCalls
then heartbeat timestamp is updated periodically

5. Given Serverpod instance is started
when a new future call becomes due and the server shuts down before execution completes
then the claim is not deleted

6. Given Serverpod instance is started with scheduled FutureCall that is due
when the server shuts down before execution completes and is then restarted
then the future call is executed again
then the claim is deleted

For 1,2,3, and 4, use `withServerpod`.

For 5 and 6, use `IntegrationTestServer` directly instead of `withServerpod`.
You can reference `tests/serverpod_test_server/test_integration/future_calls/broken_future_calls_test.dart` to see some examples.
