BEGIN;

--
-- Add index on serverpod_session_log.time for efficient time-based log cleanup
--
CREATE INDEX IF NOT EXISTS "serverpod_session_log_time_idx" ON "serverpod_session_log" USING btree ("time");

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260120153350', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260120153350', "timestamp" = now();

COMMIT;
