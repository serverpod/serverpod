--
-- Class Address as table address
--

CREATE TABLE "address" (
  "id" serial,
  "street" text NOT NULL,
  "inhabitantId" integer
);

ALTER TABLE ONLY "address"
  ADD CONSTRAINT address_pkey PRIMARY KEY (id);

--
-- Class Citizen as table citizen
--

CREATE TABLE "citizen" (
  "id" serial,
  "name" text NOT NULL,
  "companyId" integer NOT NULL,
  "oldCompanyId" integer,
  "_companyEmployeesCompanyId" integer
);

ALTER TABLE ONLY "citizen"
  ADD CONSTRAINT citizen_pkey PRIMARY KEY (id);

--
-- Class Company as table company
--

CREATE TABLE "company" (
  "id" serial,
  "name" text NOT NULL,
  "townId" integer NOT NULL
);

ALTER TABLE ONLY "company"
  ADD CONSTRAINT company_pkey PRIMARY KEY (id);

--
-- Class ObjectFieldScopes as table object_field_scopes
--

CREATE TABLE "object_field_scopes" (
  "id" serial,
  "normal" text NOT NULL,
  "database" text
);

ALTER TABLE ONLY "object_field_scopes"
  ADD CONSTRAINT object_field_scopes_pkey PRIMARY KEY (id);

--
-- Class ObjectWithByteData as table object_with_bytedata
--

CREATE TABLE "object_with_bytedata" (
  "id" serial,
  "byteData" bytea NOT NULL
);

ALTER TABLE ONLY "object_with_bytedata"
  ADD CONSTRAINT object_with_bytedata_pkey PRIMARY KEY (id);

--
-- Class ObjectWithDuration as table object_with_duration
--

CREATE TABLE "object_with_duration" (
  "id" serial,
  "duration" bigint NOT NULL
);

ALTER TABLE ONLY "object_with_duration"
  ADD CONSTRAINT object_with_duration_pkey PRIMARY KEY (id);

--
-- Class ObjectWithEnum as table object_with_enum
--

CREATE TABLE "object_with_enum" (
  "id" serial,
  "testEnum" integer NOT NULL,
  "nullableEnum" integer,
  "enumList" json NOT NULL,
  "nullableEnumList" json NOT NULL,
  "enumListList" json NOT NULL
);

ALTER TABLE ONLY "object_with_enum"
  ADD CONSTRAINT object_with_enum_pkey PRIMARY KEY (id);

--
-- Class ObjectWithIndex as table object_with_index
--

CREATE TABLE "object_with_index" (
  "id" serial,
  "indexed" integer NOT NULL,
  "indexed2" integer NOT NULL
);

ALTER TABLE ONLY "object_with_index"
  ADD CONSTRAINT object_with_index_pkey PRIMARY KEY (id);

CREATE INDEX object_with_index_test_index ON "object_with_index" USING brin ("indexed", "indexed2");

--
-- Class ObjectWithObject as table object_with_object
--

CREATE TABLE "object_with_object" (
  "id" serial,
  "data" json NOT NULL,
  "nullableData" json,
  "dataList" json NOT NULL,
  "nullableDataList" json,
  "listWithNullableData" json NOT NULL,
  "nullableListWithNullableData" json
);

ALTER TABLE ONLY "object_with_object"
  ADD CONSTRAINT object_with_object_pkey PRIMARY KEY (id);

--
-- Class ObjectWithParent as table object_with_parent
--

CREATE TABLE "object_with_parent" (
  "id" serial,
  "other" integer NOT NULL
);

ALTER TABLE ONLY "object_with_parent"
  ADD CONSTRAINT object_with_parent_pkey PRIMARY KEY (id);

--
-- Class ObjectWithSelfParent as table object_with_self_parent
--

CREATE TABLE "object_with_self_parent" (
  "id" serial,
  "other" integer
);

ALTER TABLE ONLY "object_with_self_parent"
  ADD CONSTRAINT object_with_self_parent_pkey PRIMARY KEY (id);

--
-- Class ObjectWithUuid as table object_with_uuid
--

CREATE TABLE "object_with_uuid" (
  "id" serial,
  "uuid" uuid NOT NULL,
  "uuidNullable" uuid
);

ALTER TABLE ONLY "object_with_uuid"
  ADD CONSTRAINT object_with_uuid_pkey PRIMARY KEY (id);

--
-- Class Post as table post
--

CREATE TABLE "post" (
  "id" serial,
  "content" text NOT NULL,
  "nextId" integer
);

ALTER TABLE ONLY "post"
  ADD CONSTRAINT post_pkey PRIMARY KEY (id);

--
-- Class RelatedUniqueData as table related_unique_data
--

CREATE TABLE "related_unique_data" (
  "id" serial,
  "uniqueDataId" integer NOT NULL,
  "number" integer NOT NULL
);

ALTER TABLE ONLY "related_unique_data"
  ADD CONSTRAINT related_unique_data_pkey PRIMARY KEY (id);

--
-- Class SimpleData as table simple_data
--

CREATE TABLE "simple_data" (
  "id" serial,
  "num" integer NOT NULL
);

ALTER TABLE ONLY "simple_data"
  ADD CONSTRAINT simple_data_pkey PRIMARY KEY (id);

--
-- Class SimpleDateTime as table simple_date_time
--

CREATE TABLE "simple_date_time" (
  "id" serial,
  "dateTime" timestamp without time zone NOT NULL
);

ALTER TABLE ONLY "simple_date_time"
  ADD CONSTRAINT simple_date_time_pkey PRIMARY KEY (id);

--
-- Class Town as table town
--

CREATE TABLE "town" (
  "id" serial,
  "name" text NOT NULL,
  "mayorId" integer
);

ALTER TABLE ONLY "town"
  ADD CONSTRAINT town_pkey PRIMARY KEY (id);

--
-- Class Types as table types
--

CREATE TABLE "types" (
  "id" serial,
  "anInt" integer,
  "aBool" boolean,
  "aDouble" double precision,
  "aDateTime" timestamp without time zone,
  "aString" text,
  "aByteData" bytea,
  "aDuration" bigint,
  "aUuid" uuid,
  "anEnum" integer
);

ALTER TABLE ONLY "types"
  ADD CONSTRAINT types_pkey PRIMARY KEY (id);

--
-- Class UniqueData as table unique_data
--

CREATE TABLE "unique_data" (
  "id" serial,
  "number" integer NOT NULL,
  "email" text NOT NULL
);

ALTER TABLE ONLY "unique_data"
  ADD CONSTRAINT unique_data_pkey PRIMARY KEY (id);

CREATE UNIQUE INDEX email_index_idx ON "unique_data" USING btree ("email");

--
-- Foreign relations for "address" table
--

ALTER TABLE ONLY "address"
  ADD CONSTRAINT address_fk_0
    FOREIGN KEY("inhabitantId")
      REFERENCES citizen(id)
        ON DELETE CASCADE;

--
-- Foreign relations for "citizen" table
--

ALTER TABLE ONLY "citizen"
  ADD CONSTRAINT citizen_fk_0
    FOREIGN KEY("companyId")
      REFERENCES company(id)
        ON DELETE CASCADE;
ALTER TABLE ONLY "citizen"
  ADD CONSTRAINT citizen_fk_1
    FOREIGN KEY("oldCompanyId")
      REFERENCES company(id)
        ON DELETE CASCADE;
ALTER TABLE ONLY "citizen"
  ADD CONSTRAINT citizen_fk_2
    FOREIGN KEY("_companyEmployeesCompanyId")
      REFERENCES company(id)
        ON DELETE CASCADE;

--
-- Foreign relations for "company" table
--

ALTER TABLE ONLY "company"
  ADD CONSTRAINT company_fk_0
    FOREIGN KEY("townId")
      REFERENCES town(id)
        ON DELETE CASCADE;

--
-- Foreign relations for "object_with_parent" table
--

ALTER TABLE ONLY "object_with_parent"
  ADD CONSTRAINT object_with_parent_fk_0
    FOREIGN KEY("other")
      REFERENCES object_field_scopes(id)
        ON DELETE CASCADE;

--
-- Foreign relations for "object_with_self_parent" table
--

ALTER TABLE ONLY "object_with_self_parent"
  ADD CONSTRAINT object_with_self_parent_fk_0
    FOREIGN KEY("other")
      REFERENCES object_with_self_parent(id)
        ON DELETE CASCADE;

--
-- Foreign relations for "post" table
--

ALTER TABLE ONLY "post"
  ADD CONSTRAINT post_fk_0
    FOREIGN KEY("nextId")
      REFERENCES post(id)
        ON DELETE CASCADE;

--
-- Foreign relations for "related_unique_data" table
--

ALTER TABLE ONLY "related_unique_data"
  ADD CONSTRAINT related_unique_data_fk_0
    FOREIGN KEY("uniqueDataId")
      REFERENCES unique_data(id)
        ON DELETE CASCADE;

--
-- Foreign relations for "town" table
--

ALTER TABLE ONLY "town"
  ADD CONSTRAINT town_fk_0
    FOREIGN KEY("mayorId")
      REFERENCES citizen(id)
        ON DELETE CASCADE;

