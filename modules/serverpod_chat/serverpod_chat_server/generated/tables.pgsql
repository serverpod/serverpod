--
-- Class ChatMessage as table serverpod_chat_message
--

CREATE TABLE "serverpod_chat_message" (
  "id" bigserial,
  "channel" text NOT NULL,
  "message" text NOT NULL,
  "time" timestamp without time zone NOT NULL,
  "sender" bigint NOT NULL,
  "removed" boolean NOT NULL,
  "attachments" json
);

ALTER TABLE ONLY "serverpod_chat_message"
  ADD CONSTRAINT serverpod_chat_message_pkey PRIMARY KEY (id);

CREATE INDEX serverpod_chat_message_channel_idx ON "serverpod_chat_message" USING btree ("channel");


--
-- Class ChatReadMessage as table serverpod_chat_read_message
--

CREATE TABLE "serverpod_chat_read_message" (
  "id" bigserial,
  "channel" text NOT NULL,
  "userId" bigint NOT NULL,
  "lastReadMessageId" bigint NOT NULL
);

ALTER TABLE ONLY "serverpod_chat_read_message"
  ADD CONSTRAINT serverpod_chat_read_message_pkey PRIMARY KEY (id);

CREATE UNIQUE INDEX serverpod_chat_read_message_channel_user_idx ON "serverpod_chat_read_message" USING btree ("channel", "userId");


