BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_chat_message" (
    "id" serial PRIMARY KEY,
    "channel" text NOT NULL,
    "message" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "sender" integer NOT NULL,
    "removed" boolean NOT NULL,
    "attachments" json
);

-- Indexes
CREATE INDEX "serverpod_chat_message_channel_idx" ON "serverpod_chat_message" USING btree ("channel");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_chat_read_message" (
    "id" serial PRIMARY KEY,
    "channel" text NOT NULL,
    "userId" integer NOT NULL,
    "lastReadMessageId" integer NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_chat_read_message_channel_user_idx" ON "serverpod_chat_read_message" USING btree ("channel", "userId");


--
-- MIGRATION VERSION FOR serverpod_chat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_chat', '20231128143847317', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20231128143847317', "timestamp" = now();


COMMIT;
