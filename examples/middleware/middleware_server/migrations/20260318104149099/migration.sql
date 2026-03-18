BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_future_call_claim" (
    "id" bigserial PRIMARY KEY,
    "heartbeat" timestamp without time zone NOT NULL
);


--
-- MIGRATION VERSION FOR middleware
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('middleware', '20260318104149099', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260318104149099', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260318104133623', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260318104133623', "timestamp" = now();


COMMIT;
