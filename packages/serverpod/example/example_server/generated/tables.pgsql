--
-- Class Channel as table channel
--

CREATE TABLE channel (
  "id" serial,
  "name" text NOT NULL,
  "channel" text NOT NULL
);

ALTER TABLE ONLY channel
  ADD CONSTRAINT channel_pkey PRIMARY KEY (id);


