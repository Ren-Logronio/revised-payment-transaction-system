SET foreign_key_checks = 0;

DROP TABLE IF EXISTS Phone_number;
DROP TABLE IF EXISTS Wallet;
DROP TABLE IF EXISTS User_account;
DROP TABLE IF EXISTS Organization_member;
DROP TABLE IF EXISTS Member_role;
DROP TABLE IF EXISTS Payment_fine;
DROP TABLE IF EXISTS Payment_fee;
DROP TABLE IF EXISTS Payment_product_stock;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Product_offered_photos;
DROP TABLE IF EXISTS Product_stock;
DROP TABLE IF EXISTS Product_offered;
DROP TABLE IF EXISTS Student_fine;
DROP TABLE IF EXISTS Payment_status;
DROP TABLE IF EXISTS Payment_type;
DROP TABLE IF EXISTS Fee;
DROP TABLE IF EXISTS Organization_photo;
DROP TABLE IF EXISTS School_organization;
DROP TABLE IF EXISTS Account_photo;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Rating;
DROP TABLE IF EXISTS Product_review;
DROP TABLE IF EXISTS Cart;
DROP TABLE IF EXISTS Likes_review;

SET foreign_key_checks = 1;

DROP TRIGGER IF EXISTS student_insert;

CREATE TABLE IF NOT EXISTS Student (
	s_index int NOT NULL AUTO_INCREMENT UNIQUE,
    student_id VARCHAR(10) DEFAULT 'NOTSET',
    lastname VARCHAR(255),
    firstname VARCHAR(255),
    middlename VARCHAR(255),
    postfix VARCHAR(5),
    date_of_birth DATE,
    email_address VARCHAR(255) NOT NULL,
    INDEX student_id (student_id),
    PRIMARY KEY (s_index, student_id)
);

CREATE TABLE IF NOT EXISTS User_account (
	accountID int NOT NULL AUTO_INCREMENT UNIQUE,
    username VARCHAR(255) NOT NULL,
    authentication VARCHAR(5) NOT NULL CHECK (authentication IN ('ADMIN', 'USER')),
    user_password_hash VARCHAR(255) NOT NULL CHECK (char_length(user_password_hash) > 0),
    user_password_salt VARCHAR(255),
    isStudent BOOLEAN NOT NULL DEFAULT false,
    student_id VARCHAR(10),
    PRIMARY KEY (accountID),
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS Wallet (
	wallet_no int NOT NULL AUTO_INCREMENT,
    accountID int,
    balance DECIMAL(15,2),
    PRIMARY KEY (wallet_no),
    FOREIGN KEY (accountID) REFERENCES User_account(accountID) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS Phone_number (
	phone_id INT NOT NULL AUTO_INCREMENT UNIQUE,
    student_id VARCHAR(10) NOT NULL,
	phone_no VARCHAR(10) NOT NULL,
    PRIMARY KEY (phone_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Account_photo (
	AccountID int NOT NULL,
    profile_imagedata MEDIUMBLOB,
    wallpaper_imagedata MEDIUMBLOB,
    PRIMARY KEY (AccountID),
    FOREIGN KEY (AccountID) REFERENCES User_account(AccountID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS School_organization (
	org_id int NOT NULL AUTO_INCREMENT UNIQUE,
    organization_code VARCHAR(10) NOT NULL UNIQUE,
    org_description VARCHAR(255) NOT NULL,
    PRIMARY KEY (org_id, organization_code)
);

CREATE TABLE IF NOT EXISTS Organization_photo (
	organization_code VARCHAR(10) NOT NULL,
    logo_imagedata MEDIUMBLOB,
    wallpaper_imagedata MEDIUMBLOB,
    PRIMARY KEY (organization_code),
    FOREIGN KEY (organization_code) REFERENCES school_organization(organization_code) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Fee (
	fee_id int NOT NULL AUTO_INCREMENT UNIQUE,
    organization_code VARCHAR(10) NOT NULL,
    isExclusive BOOLEAN DEFAULT TRUE,
    amount DECIMAL(15,2) DEFAULT 0.00,
    PRIMARY KEY (fee_id),
    FOREIGN KEY (organization_code) REFERENCES school_organization(organization_code)
);

CREATE TABLE IF NOT EXISTS Product_offered (
	 product_id int NOT NULL AUTO_INCREMENT UNIQUE,
     organization_code VARCHAR(10) NOT NULL,
     isExclusive BOOLEAN NOT NULL DEFAULT TRUE,
     product_description VARCHAR(255),
     PRIMARY KEY (product_id),
     FOREIGN KEY (organization_code) REFERENCES school_organization(organization_code) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Product_offered_photos (
	photo_index int NOT NULL AUTO_INCREMENT UNIQUE,
	product_id int NOT NULL,
    imagedata MEDIUMBLOB,
    isMain BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (photo_index, product_id),
    FOREIGN KEY (product_id) REFERENCES product_offered(product_id)
);

CREATE TABLE IF NOT EXISTS Product_stock (
	stock_id int NOT NULL AUTO_INCREMENT UNIQUE,
    product_id int,
    stock int NOT NULL DEFAULT 0,
    stock_description VARCHAR(255),
    price DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (stock_id),
    FOREIGN KEY (product_id) REFERENCES product_offered(product_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Cart (
	stock_id int NOT NULL,
    student_id VARCHAR(10),
    FOREIGN KEY (stock_id) REFERENCES product_stock(stock_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Student_fine (
	fine_id int NOT NULL AUTO_INCREMENT UNIQUE,
    organization_code VARCHAR(10),
    student_id VARCHAR(10),
    date_issued DATE NOT NULL DEFAULT (CURRENT_DATE),
    amount DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (fine_id),
    FOREIGN KEY (organization_code) REFERENCES school_organization(organization_code) ON DELETE SET NULL,
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS Payment_status (
	status_index int NOT NULL UNIQUE,
    status_code VARCHAR(7) CHECK (status_code IN ('FULL', 'PARTIAL', 'UNPAID')),
    PRIMARY KEY (status_index)
);

CREATE TABLE IF NOT EXISTS Payment_type (
	type_index int NOT NULL UNIQUE,
	type_code VARCHAR(7) CHECK (type_code IN ('FEE', 'FINE', 'PRODUCT')),
    PRIMARY KEY (type_index, type_code)
);

CREATE TABLE IF NOT EXISTS Payment (
	transaction_no int NOT NULL AUTO_INCREMENT UNIQUE,
    student_id VARCHAR(10),
    datetime_of_transaction DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_index int NOT NULL,
    type_index int NOT NULL,
    PRIMARY KEY (transaction_no),
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE SET NULL,
    FOREIGN KEY (status_index) REFERENCES payment_status(status_index) ON DELETE RESTRICT,
    FOREIGN KEY (type_index) REFERENCES payment_type(type_index) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS Payment_fine (
	transaction_no int NOT NULL,
    fine_id int,
    PRIMARY KEY (transaction_no, fine_id),
    FOREIGN KEY (transaction_no) REFERENCES payment(transaction_no) ON DELETE RESTRICT,
    FOREIGN KEY (fine_id) REFERENCES student_fine(fine_id)
);

CREATE TABLE IF NOT EXISTS Payment_fee (
	transaction_no int NOT NULL,
    fee_id int,
    PRIMARY KEY (transaction_no, fee_id),
    FOREIGN KEY (transaction_no) REFERENCES payment(transaction_no) ON DELETE RESTRICT,
    FOREIGN KEY (fee_id) REFERENCES fee(fee_id)
);

CREATE TABLE IF NOT EXISTS Payment_product_stock (
	transaction_no int NOT NULL,
    stock_id int,
    PRIMARY KEY (transaction_no, stock_id),
    FOREIGN KEY (transaction_no) REFERENCES payment(transaction_no) ON DELETE RESTRICT,
    FOREIGN KEY (stock_id) REFERENCES product_stock(stock_id)
);

CREATE TABLE IF NOT EXISTS Rating (
	rate int NOT NULL UNIQUE,
    rate_description VARCHAR(255),
    PRIMARY KEY (rate)
);

CREATE TABLE IF NOT EXISTS Product_review (
	review_id int NOT NULL UNIQUE,
	product_id int NOT NULL,
    student_id VARCHAR(10) NOT NULL,
    rate int NOT NULL,
    comment VARCHAR(255),
    PRIMARY KEY (review_id),
    FOREIGN KEY (product_id) REFERENCES product_offered(product_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (rate) REFERENCES rating(rate)
);

CREATE TABLE IF NOT EXISTS Likes_review (
	review_id int,
    student_id VARCHAR(10),
    PRIMARY KEY (review_id, student_id),
    FOREIGN KEY (review_id) REFERENCES product_review(review_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id)
);

CREATE TABLE IF NOT EXISTS Member_role (
	role_index int NOT NULL UNIQUE,
    role_description VARCHAR(11) CHECK (role_description IN ('NONOFFICER', 'OFFICER', 'EXECOFFICER')),
    PRIMARY KEY (role_index)
);

CREATE TABLE IF NOT EXISTS Organization_member (
	organization_code VARCHAR(10) NOT NULL,
	student_id VARCHAR(10) NOT NULL,
    role_index INT NOT NULL,
    PRIMARY KEY (organization_code, student_id),
    FOREIGN KEY (organization_code) REFERENCES school_organization(organization_code),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (role_index) REFERENCES member_role(role_index)
);

INSERT INTO Payment_type (type_index, type_code)
VALUES (0, 'PRODUCT'), 
(1, 'FEE'), 
(2, 'FINE');

INSERT INTO Payment_status (status_index, status_code)
VALUES (0, 'UNPAID'), 
(1, 'PARTIAL'), 
(2, 'FULL');

INSERT INTO Member_role (role_index, role_description)
VALUES (0, 'NONOFFICER'),
(1, 'OFFICER'),
(2, 'EXECOFFICER');

INSERT INTO Rating (rate, rate_description)
VALUES (1, 'POOR'),
(2, 'FAIR'),
(3, 'GOOD'),
(4, 'VERY GOOD'),
(5, 'PERFECT');

