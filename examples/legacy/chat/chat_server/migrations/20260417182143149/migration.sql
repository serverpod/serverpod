BEGIN;

--
-- ACTION ALTER TABLE
--
DROP INDEX "serverpod_log_sessionLogId_idx";
CREATE INDEX "serverpod_log_sessionLogId_idx" ON "serverpod_log" USING btree ("sessionLogId", "order");
--
-- ACTION ALTER TABLE
--
CREATE INDEX "serverpod_message_log_sessionLogId_idx" ON "serverpod_message_log" USING btree ("sessionLogId", "order");
--
-- ACTION ALTER TABLE
--
DROP INDEX "serverpod_query_log_sessionLogId_idx";
CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON "serverpod_query_log" USING btree ("sessionLogId", "order");

--
-- MIGRATION VERSION FOR chat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('chat', '20260417182143149', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260417182143149', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260416151914983-insights-perf', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260416151914983-insights-perf', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20260407154723760', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260407154723760', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_chat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_chat', '20260407154755203', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260407154755203', "timestamp" = now();


COMMIT;
