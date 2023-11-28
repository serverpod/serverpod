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
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('chat', '20231128143921588', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20231128143921588', "timestamp" = now();


COMMIT;
