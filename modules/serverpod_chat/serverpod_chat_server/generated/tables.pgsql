--
-- Class ChatMessage as table serverpod_chat_message
--

CREATE TABLE serverpod_chat_message (
  "id" serial,
  "channel" text NOT NULL,
  "type" text NOT NULL,
  "message" text NOT NULL,
  "time" timestamp without time zone NOT NULL,
  "sender" integer NOT NULL,
  "senderInfo" json,
  "removed" boolean NOT NULL
);

ALTER TABLE ONLY serverpod_chat_message
  ADD CONSTRAINT serverpod_chat_message_pkey PRIMARY KEY (id);


