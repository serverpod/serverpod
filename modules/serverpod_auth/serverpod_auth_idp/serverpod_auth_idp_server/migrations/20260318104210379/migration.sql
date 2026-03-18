BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_future_call_claim" (
    "id" bigserial PRIMARY KEY,
    "heartbeat" timestamp without time zone NOT NULL
);


--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260318104210379', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260318104210379', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260318104133623', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260318104133623', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260318104204932', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260318104204932', "timestamp" = now();


COMMIT;
