--
-- Class UserInfo as table serverpod_user_info
--

CREATE TABLE serverpod_user_info (
  "id" serial,
  "userName" text NOT NULL,
  "fullName" text,
  "email" text,
  "created" timestamp without time zone NOT NULL,
  "avatarUrl" text,
  "scopes" json NOT NULL,
  "active" boolean NOT NULL,
  "blocked" boolean NOT NULL
);

ALTER TABLE ONLY serverpod_user_info
  ADD CONSTRAINT serverpod_user_info_pkey PRIMARY KEY (id);


