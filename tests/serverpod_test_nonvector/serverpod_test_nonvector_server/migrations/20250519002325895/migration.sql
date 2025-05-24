BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "greeting" (
    "id" bigserial PRIMARY KEY,
    "message" text NOT NULL,
    "author" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL
);


--
-- MIGRATION VERSION FOR serverpod_test_nonvector
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_nonvector', '20250519002325895', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250519002325895', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
