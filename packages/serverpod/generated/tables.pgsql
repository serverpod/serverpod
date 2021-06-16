--
-- Class RuntimeSettings as table serverpod_runtime_settings
--

CREATE TABLE serverpod_runtime_settings (
  "id" serial,
  "logAllCalls" boolean NOT NULL,
  "logAllQueries" boolean NOT NULL,
  "logSlowCalls" boolean NOT NULL,
  "logSlowQueries" boolean NOT NULL,
  "logFailedCalls" boolean NOT NULL,
  "logFailedQueries" boolean NOT NULL,
  "logMalformedCalls" boolean NOT NULL,
  "logServiceCalls" boolean NOT NULL,
  "logLevel" integer NOT NULL,
  "slowQueryDuration" double precision NOT NULL,
  "slowCallDuration" double precision NOT NULL
);

ALTER TABLE ONLY serverpod_runtime_settings
  ADD CONSTRAINT serverpod_runtime_settings_pkey PRIMARY KEY (id);


--
-- Class FutureCallEntry as table serverpod_future_call
--

CREATE TABLE serverpod_future_call (
  "id" serial,
  "name" text NOT NULL,
  "time" timestamp without time zone NOT NULL,
  "serializedObject" text,
  "serverId" integer NOT NULL
);

ALTER TABLE ONLY serverpod_future_call
  ADD CONSTRAINT serverpod_future_call_pkey PRIMARY KEY (id);

CREATE INDEX serverpod_future_call_time_idx ON serverpod_future_call USING btree ("time");
CREATE INDEX serverpod_future_call_serverId_idx ON serverpod_future_call USING btree ("serverId");


--
-- Class QueryLogEntry as table serverpod_query_log
--

CREATE TABLE serverpod_query_log (
  "id" serial,
  "serverId" integer,
  "sessionLogId" integer,
  "query" text NOT NULL,
  "duration" double precision NOT NULL,
  "numRows" integer,
  "exception" text,
  "stackTrace" text
);

ALTER TABLE ONLY serverpod_query_log
  ADD CONSTRAINT serverpod_query_log_pkey PRIMARY KEY (id);

CREATE INDEX serverpod_query_log_sessionLogId_idx ON serverpod_query_log USING btree ("sessionLogId");


--
-- Class MethodInfo as table serverpod_method
--

CREATE TABLE serverpod_method (
  "id" serial,
  "endpoint" text NOT NULL,
  "method" text NOT NULL
);

ALTER TABLE ONLY serverpod_method
  ADD CONSTRAINT serverpod_method_pkey PRIMARY KEY (id);

CREATE UNIQUE INDEX serverpod_method_endpoint_method_idx ON serverpod_method USING btree ("endpoint", "method");


--
-- Class LogEntry as table serverpod_log
--

CREATE TABLE serverpod_log (
  "id" serial,
  "serverId" integer NOT NULL,
  "time" timestamp without time zone NOT NULL,
  "logLevel" integer NOT NULL,
  "message" text NOT NULL,
  "exception" text,
  "stackTrace" text,
  "sessionLogId" integer
);

ALTER TABLE ONLY serverpod_log
  ADD CONSTRAINT serverpod_log_pkey PRIMARY KEY (id);

CREATE INDEX serverpod_log_sessionLogId_idx ON serverpod_log USING btree ("sessionLogId");


--
-- Class CloudStorageEntry as table serverpod_cloud_storage
--

CREATE TABLE serverpod_cloud_storage (
  "id" serial,
  "storageId" text NOT NULL,
  "path" text NOT NULL,
  "addedTime" timestamp without time zone NOT NULL,
  "expiration" timestamp without time zone,
  "byteData" bytea NOT NULL
);

ALTER TABLE ONLY serverpod_cloud_storage
  ADD CONSTRAINT serverpod_cloud_storage_pkey PRIMARY KEY (id);

CREATE UNIQUE INDEX serverpod_cloud_storage_path_idx ON serverpod_cloud_storage USING btree ("storageId", "path");
CREATE INDEX serverpod_cloud_storage_expiration ON serverpod_cloud_storage USING btree ("expiration");


--
-- Class SessionLogEntry as table serverpod_session_log
--

CREATE TABLE serverpod_session_log (
  "id" serial,
  "serverId" integer NOT NULL,
  "time" timestamp without time zone NOT NULL,
  "endpoint" text,
  "method" text,
  "futureCall" text,
  "duration" double precision NOT NULL,
  "numQueries" integer NOT NULL,
  "slow" boolean NOT NULL,
  "error" text,
  "stackTrace" text,
  "authenticatedUserId" integer
);

ALTER TABLE ONLY serverpod_session_log
  ADD CONSTRAINT serverpod_session_log_pkey PRIMARY KEY (id);


--
-- Class AuthKey as table serverpod_auth_key
--

CREATE TABLE serverpod_auth_key (
  "id" serial,
  "userId" integer NOT NULL,
  "hash" text NOT NULL,
  "scopes" json NOT NULL,
  "method" text NOT NULL
);

ALTER TABLE ONLY serverpod_auth_key
  ADD CONSTRAINT serverpod_auth_key_pkey PRIMARY KEY (id);

CREATE INDEX serverpod_auth_key_userId_idx ON serverpod_auth_key USING btree ("userId");


--
-- Class ReadWriteTestEntry as table serverpod_readwrite_test
--

CREATE TABLE serverpod_readwrite_test (
  "id" serial,
  "number" integer NOT NULL
);

ALTER TABLE ONLY serverpod_readwrite_test
  ADD CONSTRAINT serverpod_readwrite_test_pkey PRIMARY KEY (id);


