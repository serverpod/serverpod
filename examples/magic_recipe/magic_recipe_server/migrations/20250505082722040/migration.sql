BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "recipes" ADD COLUMN "deletedAt" timestamp without time zone;

--
-- MIGRATION VERSION FOR magic_recipe
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('magic_recipe', '20250505082722040', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250505082722040', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
