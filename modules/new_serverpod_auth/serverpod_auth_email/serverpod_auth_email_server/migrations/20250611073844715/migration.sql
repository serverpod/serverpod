BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_cloud_storage" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "addedTime" timestamp without time zone NOT NULL,
    "expiration" timestamp without time zone,
    "byteData" bytea NOT NULL,
    "verified" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_path_idx" ON "serverpod_cloud_storage" USING btree ("storageId", "path");
CREATE INDEX "serverpod_cloud_storage_expiration" ON "serverpod_cloud_storage" USING btree ("expiration");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_cloud_storage_direct_upload" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_upload_storage_path" ON "serverpod_cloud_storage_direct_upload" USING btree ("storageId", "path");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_future_call" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "serializedObject" text,
    "serverId" text NOT NULL,
    "identifier" text
);

-- Indexes
CREATE INDEX "serverpod_future_call_time_idx" ON "serverpod_future_call" USING btree ("time");
CREATE INDEX "serverpod_future_call_serverId_idx" ON "serverpod_future_call" USING btree ("serverId");
CREATE INDEX "serverpod_future_call_identifier_idx" ON "serverpod_future_call" USING btree ("identifier");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_health_connection_info" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "active" bigint NOT NULL,
    "closing" bigint NOT NULL,
    "idle" bigint NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_connection_info_timestamp_idx" ON "serverpod_health_connection_info" USING btree ("timestamp", "serverId", "granularity");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_health_metric" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "isHealthy" boolean NOT NULL,
    "value" double precision NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_metric_timestamp_idx" ON "serverpod_health_metric" USING btree ("timestamp", "serverId", "name", "granularity");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "reference" text,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "logLevel" bigint NOT NULL,
    "message" text NOT NULL,
    "error" text,
    "stackTrace" text,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_log_sessionLogId_idx" ON "serverpod_log" USING btree ("sessionLogId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_message_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "serverId" text NOT NULL,
    "messageId" bigint NOT NULL,
    "endpoint" text NOT NULL,
    "messageName" text NOT NULL,
    "duration" double precision NOT NULL,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_method" (
    "id" bigserial PRIMARY KEY,
    "endpoint" text NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_method_endpoint_method_idx" ON "serverpod_method" USING btree ("endpoint", "method");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_migrations" (
    "id" bigserial PRIMARY KEY,
    "module" text NOT NULL,
    "version" text NOT NULL,
    "timestamp" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_migrations_ids" ON "serverpod_migrations" USING btree ("module");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_query_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "query" text NOT NULL,
    "duration" double precision NOT NULL,
    "numRows" bigint,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON "serverpod_query_log" USING btree ("sessionLogId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_readwrite_test" (
    "id" bigserial PRIMARY KEY,
    "number" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_runtime_settings" (
    "id" bigserial PRIMARY KEY,
    "logSettings" json NOT NULL,
    "logSettingsOverrides" json NOT NULL,
    "logServiceCalls" boolean NOT NULL,
    "logMalformedCalls" boolean NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_session_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "module" text,
    "endpoint" text,
    "method" text,
    "duration" double precision,
    "numQueries" bigint,
    "slow" boolean,
    "error" text,
    "stackTrace" text,
    "authenticatedUserId" bigint,
    "isOpen" boolean,
    "touched" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_session_log_serverid_idx" ON "serverpod_session_log" USING btree ("serverId");
CREATE INDEX "serverpod_session_log_touched_idx" ON "serverpod_session_log" USING btree ("touched");
CREATE INDEX "serverpod_session_log_isopen_idx" ON "serverpod_session_log" USING btree ("isOpen");

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
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_profile_user_profile" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "authUserId" uuid NOT NULL,
    "userName" text,
    "fullName" text,
    "email" text,
    "created" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "imageId" uuid
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_profile_user_profile_email_auth_user_id" ON "serverpod_auth_profile_user_profile" USING btree ("authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_profile_user_profile_image" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "userProfileId" uuid NOT NULL,
    "created" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "url" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_session" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "authUserId" uuid NOT NULL,
    "created" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "scopeNames" json NOT NULL,
    "sessionKeyHash" bytea NOT NULL,
    "sessionKeySalt" bytea NOT NULL,
    "method" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_user" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "created" timestamp without time zone NOT NULL,
    "scopeNames" json NOT NULL,
    "blocked" boolean NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_log"
    ADD CONSTRAINT "serverpod_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_message_log"
    ADD CONSTRAINT "serverpod_message_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_query_log"
    ADD CONSTRAINT "serverpod_query_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
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
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_profile_user_profile"
    ADD CONSTRAINT "serverpod_auth_profile_user_profile_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_profile_user_profile"
    ADD CONSTRAINT "serverpod_auth_profile_user_profile_fk_1"
    FOREIGN KEY("imageId")
    REFERENCES "serverpod_auth_profile_user_profile_image"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_profile_user_profile_image"
    ADD CONSTRAINT "serverpod_auth_profile_user_profile_image_fk_0"
    FOREIGN KEY("userProfileId")
    REFERENCES "serverpod_auth_profile_user_profile"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_session"
    ADD CONSTRAINT "serverpod_auth_session_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_auth_email
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_email', '20250611073844715', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250611073844715', "timestamp" = now();

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
-- MIGRATION VERSION FOR serverpod_auth_profile
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_profile', '20250519092101868', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250519092101868', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_session
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_session', '20250607101155018', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250607101155018', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_user
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_user', '20250506070330492', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250506070330492', "timestamp" = now();


COMMIT;
