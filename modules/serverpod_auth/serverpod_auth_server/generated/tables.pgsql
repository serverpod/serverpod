--
-- Class UserInfo as table serverpod_user_info
--

CREATE TABLE serverpod_user_info (
  "id" serial,
  "userIdentifier" text NOT NULL,
  "userName" text NOT NULL,
  "fullName" text,
  "email" text,
  "created" timestamp without time zone NOT NULL,
  "avatarUrl" text,
  "scopes" json NOT NULL,
  "active" boolean NOT NULL,
  "blocked" boolean NOT NULL,
  "suspendedUntil" timestamp without time zone
);

ALTER TABLE ONLY serverpod_user_info
  ADD CONSTRAINT serverpod_user_info_pkey PRIMARY KEY (id);

CREATE UNIQUE INDEX serverpod_user_info_user_identifier ON serverpod_user_info USING btree ("userIdentifier");
CREATE INDEX serverpod_user_info_email ON serverpod_user_info USING btree ("email");


