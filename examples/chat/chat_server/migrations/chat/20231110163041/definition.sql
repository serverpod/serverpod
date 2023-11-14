BEGIN;

--
-- Class Channel as table channel
--
CREATE TABLE "channel" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "channel" text NOT NULL
);

--
-- MIGRATION VERSION FOR chat
--
INSERT INTO "serverpod_migrations" ("module", "version", "priority", "timestamp")
    VALUES ('chat', '20231110163041', 2, now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20231110163041', "priority" = 2;


COMMIT;
