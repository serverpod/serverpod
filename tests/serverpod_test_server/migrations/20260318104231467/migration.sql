BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_future_call_claim" (
    "id" bigserial PRIMARY KEY,
    "heartbeat" timestamp without time zone NOT NULL
);


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20260318104231467', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260318104231467', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260318104133623', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260318104133623', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20260318104159451', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260318104159451', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20260129181225792', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181225792', "timestamp" = now();


COMMIT;
