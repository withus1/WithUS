CREATE DATABASE IF NOT EXISTS withus
DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

USE withus;


CREATE TABLE IF NOT EXISTS USER(
	no INT UNSIGNED PRIMARY KEY,
	id VARCHAR(16) UNIQUE not null,
	jsonstr VARCHAR(4196)
);

CREATE TABLE IF NOT EXISTS FEED(
   NO INT UNSIGNED PRIMARY KEY,
   ID VARCHAR(16) not null,
   JSONSTR VARCHAR(8192)
);

CREATE TABLE IF NOT EXISTS NOTICE(
	NO INT UNSIGNED PRIMARY KEY,
	JSONSTR VARCHAR(8192)
);

CREATE TABLE IF NOT EXISTS CHAT(
	chatID INT PRIMARY KEY AUTO_INCREMENT,
	fromID VARCHAR(20),
	toID VARCHAR(20),
	chatContent VARCHAR(100),
	chatTime DATETIME,
	chatRead INT
);