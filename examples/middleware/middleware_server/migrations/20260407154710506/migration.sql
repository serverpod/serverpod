BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_future_call" ADD COLUMN "scheduling" json;

--
-- MIGRATION VERSION FOR middleware
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('middleware', '20260407154710506', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260407154710506', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260407154349528', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260407154349528', "timestamp" = now();


COMMIT;
