BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_future_call" ADD COLUMN "scheduling" json;

--
-- MIGRATION VERSION FOR chat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('chat', '20260407154656533', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260407154656533', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260407154349528', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260407154349528', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20260324085838223', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260324085838223', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_chat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_chat', '20260324085908753', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260324085908753', "timestamp" = now();


COMMIT;
