BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_backwards_compatibility_email_password" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "emailAccountId" uuid NOT NULL,
    "hash" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_backwards_compatibility_email_password_account" ON "serverpod_auth_backwards_compatibility_email_password" USING btree ("emailAccountId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_backwards_compatibility_external_user_id" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "authUserId" uuid NOT NULL,
    "userIdentifier" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_backwards_compatibility_external_user_id_id" ON "serverpod_auth_backwards_compatibility_external_user_id" USING btree ("userIdentifier");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_backwards_compatibility_session" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "scopeNames" json NOT NULL,
    "lastUsed" timestamp without time zone,
    "hash" text NOT NULL,
    "method" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_email_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "authUserId" uuid NOT NULL,
    "created" timestamp without time zone NOT NULL,
    "email" text NOT NULL,
    "passwordHash" bytea NOT NULL,
    "passwordSalt" bytea NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_email_account_email" ON "serverpod_auth_email_account" USING btree ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_email_account_failed_login_attempt" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "email" text NOT NULL,
    "attemptedAt" timestamp without time zone NOT NULL,
    "ipAddress" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_auth_email_account_failed_login_attempt_email" ON "serverpod_auth_email_account_failed_login_attempt" USING btree ("email");
CREATE INDEX "serverpod_auth_email_account_failed_login_attempt_attempted_at" ON "serverpod_auth_email_account_failed_login_attempt" USING btree ("attemptedAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_email_account_password_reset_attempt" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "attemptedAt" timestamp without time zone NOT NULL,
    "ipAddress" text NOT NULL,
    "passwordResetRequestId" uuid NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_auth_email_account_password_reset_attempt_ip" ON "serverpod_auth_email_account_password_reset_attempt" USING btree ("ipAddress");
CREATE INDEX "serverpod_auth_email_account_password_reset_attempt_at" ON "serverpod_auth_email_account_password_reset_attempt" USING btree ("attemptedAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_email_account_password_reset_request" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "emailAccountId" uuid NOT NULL,
    "created" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "verificationCodeHash" bytea NOT NULL,
    "verificationCodeSalt" bytea NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_email_account_pw_reset_request_attempt" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "email" text NOT NULL,
    "attemptedAt" timestamp without time zone NOT NULL,
    "ipAddress" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_auth_email_account_pw_reset_request_attempt_email" ON "serverpod_auth_email_account_pw_reset_request_attempt" USING btree ("email");
CREATE INDEX "serverpod_auth_email_account_pw_reset_request_attempt_ip" ON "serverpod_auth_email_account_pw_reset_request_attempt" USING btree ("ipAddress");
CREATE INDEX "serverpod_auth_email_account_pw_reset_request_attempt_at" ON "serverpod_auth_email_account_pw_reset_request_attempt" USING btree ("attemptedAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_email_account_request" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "created" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "email" text NOT NULL,
    "passwordHash" bytea NOT NULL,
    "passwordSalt" bytea NOT NULL,
    "verificationCodeHash" bytea NOT NULL,
    "verificationCodeSalt" bytea NOT NULL,
    "verifiedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_email_account_request_email" ON "serverpod_auth_email_account_request" USING btree ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_email_account_request_completion_attempt" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "attemptedAt" timestamp without time zone NOT NULL,
    "ipAddress" text NOT NULL,
    "emailAccountRequestId" uuid NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_auth_email_account_request_completion_attempt_ip" ON "serverpod_auth_email_account_request_completion_attempt" USING btree ("ipAddress");
CREATE INDEX "serverpod_auth_email_account_request_completion_attempt_at" ON "serverpod_auth_email_account_request_completion_attempt" USING btree ("attemptedAt");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_backwards_compatibility_email_password"
    ADD CONSTRAINT "serverpod_auth_backwards_compatibility_email_password_fk_0"
    FOREIGN KEY("emailAccountId")
    REFERENCES "serverpod_auth_email_account"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_backwards_compatibility_external_user_id"
    ADD CONSTRAINT "serverpod_auth_backwards_compatibility_external_user_id_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_backwards_compatibility_session"
    ADD CONSTRAINT "serverpod_auth_backwards_compatibility_session_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_email_account"
    ADD CONSTRAINT "serverpod_auth_email_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_email_account_password_reset_attempt"
    ADD CONSTRAINT "serverpod_auth_email_account_password_reset_attempt_fk_0"
    FOREIGN KEY("passwordResetRequestId")
    REFERENCES "serverpod_auth_email_account_password_reset_request"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_email_account_password_reset_request_fk_0"
    FOREIGN KEY("emailAccountId")
    REFERENCES "serverpod_auth_email_account"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_email_account_request_completion_attempt"
    ADD CONSTRAINT "serverpod_auth_email_account_request_completion_attempt_fk_0"
    FOREIGN KEY("emailAccountRequestId")
    REFERENCES "serverpod_auth_email_account_request"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_auth_backwards_compatibility
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_backwards_compatibility', '20250705102555966', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250705102555966', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_email_account
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_email_account', '20250606090748154', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250606090748154', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_user
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_user', '20250506070330492', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250506070330492', "timestamp" = now();


COMMIT;
