CREATE DATABASE IF NOT EXISTS withus
DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

USE withus;

CREATE TABLE IF NOT EXISTS USER(
	no INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	id VARCHAR(16) UNIQUE not null,
	jsonstr VARCHAR(1024)
);