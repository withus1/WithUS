create database if not exists withus
default character set utf8 collate utf8_general_ci;

use withus;


create table if not exists user(
	no int unsigned primary key,
	evaluation int,
	id varchar(16) unique not null,
	y varchar(128),
	x varchar(128),
	jsonstr varchar(4196)
);

create table if not exists feed(
   no int unsigned primary key,
   id varchar(16) not null,
   jsonstr varchar(8192)
);

create table if not exists notice(
	no int unsigned primary key,
	jsonstr varchar(8192)
);

create table if not exists chat(
	chatid int primary key auto_increment,
	fromid varchar(20),
	toid varchar(20),
	chatcontent varchar(100),
	chattime datetime,
	chatread int
);

create table if not exists userfeed(
	   feedno int not null,
	   userid varchar(16) not null
);
