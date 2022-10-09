CREATE DATABASE payment_system;

USE payment_system;

DROP TABLE IF EXISTS "payment_fine"
DROP TABLE IF EXISTS "payment_fee"
DROP TABLE IF EXISTS "payment_product";
DROP TABLE IF EXISTS "payment";
DROP TABLE IF EXISTS "status";
DROP TABLE IF EXISTS "cart";
DROP TABLE IF EXISTS "product_stock";
DROP TABLE IF EXISTS "size";
DROP TABLE IF EXISTS "wallet";
DROP TABLE IF EXISTS "helpful"
DROP TABLE IF EXISTS "helpful";
DROP TABLE IF EXISTS "review";
DROP TABLE IF EXISTS "rating";
DROP TABLE IF EXISTS "fine";
DROP TABLE IF EXISTS "fee";
DROP TABLE IF EXISTS "product_offered";
DROP TABLE IF EXISTS "member";
DROP TABLE IF EXISTS "organization";
DROP TABLE IF EXISTS "student";

CREATE TABLE IF NOT EXISTS "student" (
"index" INT PRIMARY KEY AUTO_INCREMENT,
"student_id" VARCHAR(10) PRIMARY KEY,
"lastname" VARCHAR,
"firstname" VARCHAR,
"middlename" VARCHAR,
"date_of_birth" DATE NOT NULL,
"email_address" VARCHAR NOT NULL
);

CREATE TABLE IF NOT EXISTS "organization" (
"organization_code" VARCHAR(15) PRIMARY KEY,
"organization_name" VARCHAR NOT NULL,
"description" TEXT
);

CREATE TABLE IF NOT EXISTS "member" (
"organization_code" VARCHAR(15),
"student_id" VARCHAR(10),
PRIMARY KEY ("organization_code", "student_id"),
FOREIGN KEY ("organization_code") REFERENCES "organization",
FOREIGN KEY ("student_id") REFERENCES "student" ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "product_offered" (
"product_id" VARCHAR(10) PRIMARY KEY,
"organization_code" VARCHAR(15),
"isExclusive" BOOLEAN DEFAULT TRUE,
"description" TEXT,
FOREIGN KEY ("organization_code") REFERENCES "organization" ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "fee" (
"fee_id" VARCHAR(10) PRIMARY KEY,
"organization_code" VARCHAR(15),
"isExclusive" BOOLEAN DEFAULT TRUE,
"amount" MONEY NOT NULL,
FOREIGN KEY ("organization_code") REFERENCES "organization" ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "fine" (
"fine_id" VARCHAR(10) PRIMARY KEY,
"organization_code" VARCHAR(15),
"amount" MONEY NOT NULL,
FOREIGN KEY ("organization_code") REFERENCES "organization" ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "rating" (
"rate" VARCHAR(2) PRIMARY KEY,
"description" VARCHAR
);

CREATE TABLE IF NOT EXISTS "review" (
"index" VARCHAR(15) PRIMARY KEY,
"student_id" VARCHAR(10),
"product_id" VARCHAR(10),
"rate" VARCHAR(2) NOT NULL,
"comment" TEXT,
FOREIGN KEY ("student_id") REFERENCES "student" ON DELETE CASCADE,
FOREIGN KEY ("rate") REFERENCES "rating" ON UPDATE CASCADE,
FOREIGN KEY ("product_id") REFERENCES "product_offered" ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "helpful" (
"student_id" VARCHAR(10),
"index" VARCHAR(10),
PRIMARY KEY ("student_id", "index"),
FOREIGN KEY ("student_id") REFERENCES "student" ON DELETE CASCADE,
FOREIGN KEY ("index") REFERENCES "review" ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "wallet" (
"reference_code" SERIAL PRIMARY KEY,
"student_id" VARCHAR(10),
"balance" MONEY NOT NULL DEFAULT 0,
FOREIGN KEY ("student_id") REFERENCES "student" ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "size" (
"size_no" NUMERIC(2, 0) PRIMARY KEY,
"description" VARCHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS "product_stock" (
"stock_id" VARCHAR(10) PRIMARY KEY,
"product_id" VARCHAR(10),
"size_no" NUMERIC(2, 0) DEFAULT 0,
"stock" NUMERIC(5, 0),
"price" MONEY NOT NULL,
FOREIGN KEY ("product_id") REFERENCES "product_offered",
FOREIGN KEY ("size_no") REFERENCES "size" ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS "cart" (
"student_id" VARCHAR(10),
"stock_id" VARCHAR(10),
PRIMARY KEY ("student_id", "stock_id"),
FOREIGN KEY ("stock_id") REFERENCES "product_stock" ON DELETE CASCADE,
FOREIGN KEY ("student_id") REFERENCES "student" ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "status" (
"status_index" NUMERIC(2, 0) PRIMARY KEY,
"status_description" VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS "payment" (
"transaction_no" SERIAL PRIMARY KEY,
"student_id" VARCHAR(10),
"date_of_transaction" DATE NOT NULL DEFAULT CURRENT_DATE,
"time_of_transaction" TIME NOT NULL DEFAULT CURRENT_TIME,
"status_index" NUMERIC(2, 0),
FOREIGN KEY ("student_id") REFERENCES "student" ON DELETE SET NULL,
FOREIGN KEY ("status_index") REFERENCES "status"
);

CREATE TABLE IF NOT EXISTS "payment_product" (
"transaction_no" SERIAL,
"stock_id" VARCHAR(10),
PRIMARY KEY ("transaction_no", "stock_id"),
FOREIGN KEY ("transaction_no") REFERENCES "payment",
FOREIGN KEY ("stock_id") REFERENCES "product_stock"
);

CREATE TABLE IF NOT EXISTS "payment_fee" (
"transaction_no" SERIAL,
"fee_id" VARCHAR(10),
PRIMARY KEY ("transaction_no", "fee_id"),
FOREIGN KEY ("transaction_no") REFERENCES "payment",
FOREIGN KEY ("fee_id") REFERENCES "fee"
);

CREATE TABLE IF NOT EXISTS "payment_fine" (
"transaction_no" SERIAL,
"fine_id" VARCHAR(10),
PRIMARY KEY ("transaction_no", "fine_id"),
FOREIGN KEY ("transaction_no") REFERENCES "payment",
FOREIGN KEY ("fine_id") REFERENCES "fine"
);