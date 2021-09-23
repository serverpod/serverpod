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
  "imageUrl" text,
  "scopes" json NOT NULL,
  "active" boolean NOT NULL,
  "blocked" boolean NOT NULL,
  "suspendedUntil" timestamp without time zone
);

ALTER TABLE ONLY serverpod_user_info
  ADD CONSTRAINT serverpod_user_info_pkey PRIMARY KEY (id);

CREATE UNIQUE INDEX serverpod_user_info_user_identifier ON serverpod_user_info USING btree ("userIdentifier");
CREATE INDEX serverpod_user_info_email ON serverpod_user_info USING btree ("email");


--
-- Class EmailAuth as table serverpod_email_auth
--

CREATE TABLE serverpod_email_auth (
  "id" serial,
  "userId" integer NOT NULL,
  "email" text NOT NULL,
  "hash" text NOT NULL
);

ALTER TABLE ONLY serverpod_email_auth
  ADD CONSTRAINT serverpod_email_auth_pkey PRIMARY KEY (id);

CREATE INDEX serverpod_email_auth_email ON serverpod_email_auth USING btree ("email");


--
-- Class UserImage as table serverpod_user_image
--

CREATE TABLE serverpod_user_image (
  "id" serial,
  "userId" integer NOT NULL,
  "version" integer NOT NULL,
  "url" text NOT NULL
);

ALTER TABLE ONLY serverpod_user_image
  ADD CONSTRAINT serverpod_user_image_pkey PRIMARY KEY (id);

CREATE INDEX serverpod_user_image_user_id ON serverpod_user_image USING btree ("userId", "version");


