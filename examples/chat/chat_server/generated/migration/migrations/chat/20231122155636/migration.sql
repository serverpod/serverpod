BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "channel" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "channel" text NOT NULL
);


--
-- MIGRATION VERSION FOR chat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('chat', '20231122155636', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20231122155636', "timestamp" = now();


COMMIT;
