BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_future_call" ADD COLUMN "scheduling" json;

--
-- MIGRATION VERSION FOR auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('auth', '20260407154703654', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260407154703654', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260407154349528', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260407154349528', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260324085850822', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260324085850822', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260324085844499', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260324085844499', "timestamp" = now();


COMMIT;
