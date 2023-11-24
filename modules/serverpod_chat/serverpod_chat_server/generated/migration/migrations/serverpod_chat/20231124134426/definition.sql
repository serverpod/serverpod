BEGIN;

--
-- Class ChatMessage as table serverpod_chat_message
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
-- Class ChatReadMessage as table serverpod_chat_read_message
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
    VALUES ('serverpod_chat', '20231124134426', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20231124134426', "timestamp" = now();


COMMIT;
