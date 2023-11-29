BEGIN;
SAVEPOINT table_setup

--
-- ACTION CREATE TABLE
--
CREATE TABLE "channel" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "channel" text NOT NULL
);


RELEASE SAVEPOINT table_setup;
--
-- MIGRATION VERSION FOR chat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('chat', '20231129111637710', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20231129111637710', "timestamp" = now();


COMMIT;
