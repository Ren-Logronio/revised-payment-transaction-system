SET foreign_key_checks = 0;

DROP TABLE IF EXISTS phone_number;
DROP TABLE IF EXISTS wallet;
DROP TABLE IF EXISTS organization_member;
DROP TABLE IF EXISTS member_roles;
DROP TABLE IF EXISTS payment_fine;
DROP TABLE IF EXISTS payment_fee;
DROP TABLE IF EXISTS payment_product_stock;
DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS product_stock;
DROP TABLE IF EXISTS product_offered;
DROP TABLE IF EXISTS student_fine;
DROP TABLE IF EXISTS payment_status;
DROP TABLE IF EXISTS fee;
DROP TABLE IF EXISTS school_organization;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS rating;
DROP TABLE IF EXISTS product_review;
DROP TABLE IF EXISTS cart;
DROP TABLE IF EXISTS likes_review;

SET foreign_key_checks = 1;

CREATE TABLE IF NOT EXISTS student (
	s_index int NOT NULL AUTO_INCREMENT UNIQUE,
    student_id VARCHAR(10) NOT NULL,
    lastname TINYTEXT,
    firstname TINYTEXT,
    middlename TINYTEXT,
    postfix VARCHAR(5),
    date_of_birth DATE,
    email_address TINYTEXT NOT NULL,
    INDEX student_id (student_id),
    PRIMARY KEY (s_index, student_id)
);

CREATE TABLE IF NOT EXISTS wallet (
	wallet_no INT NOT NULL AUTO_INCREMENT,
    student_id VARCHAR(10),
    balance DECIMAL(15,2),
    PRIMARY KEY (wallet_no),
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS phone_number (
	phone_id INT NOT NULL AUTO_INCREMENT UNIQUE,
    student_id VARCHAR(10) NOT NULL,
	phone_no VARCHAR(10) NOT NULL,
    PRIMARY KEY (phone_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS school_organization (
	org_id int NOT NULL AUTO_INCREMENT UNIQUE,
    organization_code VARCHAR(10) NOT NULL,
    org_description TINYTEXT NOT NULL,
    INDEX organization_code (organization_code),
    PRIMARY KEY (org_id, organization_code)
);

CREATE TABLE IF NOT EXISTS fee (
	fee_id int NOT NULL AUTO_INCREMENT UNIQUE,
    organization_code VARCHAR(10) NOT NULL,
    isExclusive BOOLEAN DEFAULT TRUE,
    amount DECIMAL(15,2) DEFAULT 0.00,
    PRIMARY KEY (fee_id),
    FOREIGN KEY (organization_code) REFERENCES school_organization(organization_code)
);

CREATE TABLE IF NOT EXISTS product_offered (
	 product_id int NOT NULL AUTO_INCREMENT UNIQUE,
     organization_code VARCHAR(10) NOT NULL,
     isExclusive BOOLEAN NOT NULL DEFAULT TRUE,
     product_description TINYTEXT,
     PRIMARY KEY (product_id),
     FOREIGN KEY (organization_code) REFERENCES school_organization(organization_code) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS product_stock (
	stock_id int NOT NULL AUTO_INCREMENT UNIQUE,
    product_id int,
    stock int NOT NULL DEFAULT 0,
    stock_description TINYTEXT,
    price DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (stock_id),
    FOREIGN KEY (product_id) REFERENCES product_offered(product_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS cart (
	stock_id int NOT NULL,
    student_id VARCHAR(10),
    FOREIGN KEY (stock_id) REFERENCES product_stock(stock_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS student_fine (
	fine_id int NOT NULL AUTO_INCREMENT UNIQUE,
    organization_code VARCHAR(10),
    student_id VARCHAR(10),
    date_issued DATE NOT NULL DEFAULT (CURRENT_DATE),
    amount DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (fine_id),
    FOREIGN KEY (organization_code) REFERENCES school_organization(organization_code) ON DELETE SET NULL,
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS payment_status (
	status_index int NOT NULL UNIQUE,
    status_code VARCHAR(7) CHECK (status_code IN ('FULL', 'PARTIAL', 'UNPAID')),
    PRIMARY KEY (status_index)
);

CREATE TABLE IF NOT EXISTS payment_type (
	type_index int NOT NULL UNIQUE,
	type_code VARCHAR(7) CHECK (type_code IN ('FEE', 'FINE', 'PRODUCT')),
    PRIMARY KEY (type_index, type_code)
);

CREATE TABLE IF NOT EXISTS payment_fine (
	transaction_no int NOT NULL AUTO_INCREMENT UNIQUE,
    fine_id int,
    student_id VARCHAR(10),
    datetime_of_transaction DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_index int NOT NULL,
    PRIMARY KEY (transaction_no, fine_id),
    FOREIGN KEY (fine_id) REFERENCES student_fine(fine_id),
    FOREIGN KEY (status_index) REFERENCES payment_status(status_index) ON DELETE RESTRICT,
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS payment_fee (
	transaction_no int NOT NULL AUTO_INCREMENT UNIQUE,
    fee_id int,
    student_id VARCHAR(10),
    datetime_of_transaction DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_index int NOT NULL,
    PRIMARY KEY (transaction_no, fee_id),
    FOREIGN KEY (fee_id) REFERENCES fee(fee_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE SET NULL,
    FOREIGN KEY (status_index) REFERENCES payment_status(status_index) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS payment_product_stock (
	transaction_no int NOT NULL AUTO_INCREMENT UNIQUE,
    stock_id int,
    student_id VARCHAR(10),
    status_index int NOT NULL,
    PRIMARY KEY (transaction_no, stock_id),
    FOREIGN KEY (stock_id) REFERENCES product_stock(stock_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE SET NULL,
    FOREIGN KEY (status_index) REFERENCES payment_status(status_index) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS rating (
	rate int NOT NULL UNIQUE,
    rate_description TINYTEXT,
    PRIMARY KEY (rate)
);

CREATE TABLE IF NOT EXISTS product_review (
	review_id int NOT NULL UNIQUE,
	product_id int NOT NULL,
    student_id VARCHAR(10) NOT NULL,
    rate int NOT NULL,
    comment TINYTEXT,
    PRIMARY KEY (review_id),
    FOREIGN KEY (product_id) REFERENCES product_offered(product_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (rate) REFERENCES rating(rate)
);

CREATE TABLE IF NOT EXISTS likes_review (
	review_id int,
    student_id VARCHAR(10),
    PRIMARY KEY (review_id, student_id),
    FOREIGN KEY (review_id) REFERENCES product_review(review_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id)
);

CREATE TABLE IF NOT EXISTS member_roles (
	role_index int NOT NULL AUTO_INCREMENT,
    role_description VARCHAR(50) CHECK (role_description IN ('member', 'officer')),
    INDEX role_index (role_index),
    PRIMARY KEY (role_index)
);

CREATE TABLE IF NOT EXISTS organization_member (
	organization_code VARCHAR(10) NOT NULL,
	student_id VARCHAR(10) NOT NULL,
    role_index INT NOT NULL,
    PRIMARY KEY (organization_code, student_id),
    FOREIGN KEY (organization_code) REFERENCES school_organization(organization_code),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (role_index) REFERENCES member_roles(role_index)
);

INSERT INTO payment_type (type_index, type_code)
VALUES (0, 'PRODUCT'), 
(1, 'FEE'), 
(2, 'FINE');

INSERT INTO payment_status (status_index, status_code)
VALUES (0, 'UNPAID'), 
(1, 'PARTIAL'), 
(2, 'FULL');

INSERT INTO member_role (role_index, role_description)
VALUES (0, 'NONOFFICER'),
(1, 'OFFICER');

INSERT INTO rating (rate, rate_description)
VALUES (1, 'POOR'),
(2, 'FAIR'),
(3, 'GOOD'),
(4, 'VERY GOOD'),
(5, 'PERFECT');

