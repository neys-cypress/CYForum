
/* Drop Indexes */

DROP INDEX CY_FORUM_CATEGORY_ID_IDX;
DROP INDEX FORUM_CATEGORY_ID_IDX;
DROP INDEX GROUP_PARENT_ID_IDX;



/* Drop Triggers */

DROP TRIGGER TRI_CATEGORY_CATEGORY_ID;
DROP TRIGGER TRI_CATEGORY_ID;
DROP TRIGGER TRI_CY_FORUM_CATEGORY_ID;
DROP TRIGGER TRI_FORUMS_ID;
DROP TRIGGER TRI_FORUM_CATEGORY_ID;
DROP TRIGGER TRI_POST_ID;



/* Drop Tables */

DROP TABLE F_ATTACHMENT;
DROP TABLE F_POST_DETAILS;
DROP TABLE F_VOTE;
DROP TABLE F_POST;
DROP TABLE F_TOPIC;
DROP TABLE F_FORUM;
DROP TABLE F_CATEGORY;
DROP TABLE F_CONFIG;
DROP TABLE F_USER_GROUP;
DROP TABLE F_GROUP;
DROP TABLE F_USER;



/* Drop Sequences */

DROP SEQUENCE SEQ_CATEGORY_CATEGORY_ID;
DROP SEQUENCE SEQ_CATEGORY_ID;
DROP SEQUENCE SEQ_CY_FORUM_CATEGORY_ID;
DROP SEQUENCE SEQ_FORUMS_ID;
DROP SEQUENCE SEQ_FORUM_CATEGORY_ID;
DROP SEQUENCE SEQ_POST_ID;




/* Create Sequences */

CREATE SEQUENCE SEQ_CATEGORY_CATEGORY_ID INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE SEQ_CATEGORY_ID INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE SEQ_CY_FORUM_CATEGORY_ID INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE SEQ_FORUMS_ID INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE SEQ_FORUM_CATEGORY_ID INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE SEQ_POST_ID INCREMENT BY 1 START WITH 1;



/* Create Tables */

CREATE TABLE F_ATTACHMENT
(
	ID NUMBER(10,0) NOT NULL,
	POST_ID NUMBER(10,0),
	FILENAME VARCHAR2(256) NOT NULL,
	DESCRIPTION VARCHAR2(255),
	UPLOAD_TIME DATE,
	PRIMARY KEY (ID)
);


CREATE TABLE F_CATEGORY
(
	-- This table defines the base categories of the forum
	ID NUMBER(10,0) NOT NULL,
	-- The title of the category
	TITLE VARCHAR2(64) NOT NULL,
	-- the order of the categories in the home page
	DISPLAY_ORDER NUMBER(3) NOT NULL,
	IS_MODERATED CHAR(1) DEFAULT '''Y''',
	-- This table defines the base categories of the forum
	PARENT_ID NUMBER(10,0) NOT NULL,
	CONSTRAINT cy_forum_category_pk PRIMARY KEY (ID)
);


CREATE TABLE F_CONFIG
(
	ID NUMBER(10,0) NOT NULL,
	NAME VARCHAR2(256) NOT NULL,
	VALUE VARCHAR2(256),
	PRIMARY KEY (ID)
);


CREATE TABLE F_FORUM
(
	ID NUMBER(10,0) NOT NULL,
	-- This table defines the base categories of the forum
	CATEGORY_ID NUMBER(10,0) NOT NULL,
	NAME VARCHAR2(128) NOT NULL,
	DESCRIPTION VARCHAR2(256),
	SORT_ORDER NUMBER(10,0),
	TOPICS NUMBER(10,0),
	PRIMARY KEY (ID)
);


CREATE TABLE F_GROUP
(
	ID NUMBER(10,0) NOT NULL,
	NAME VARCHAR2(128),
	DESCRIPTION VARCHAR2(256),
	PARENT_ID NUMBER(10,0) NOT NULL,
	PRIMARY KEY (ID)
);


CREATE TABLE F_POST
(
	ID NUMBER(10,0) NOT NULL,
	TOPIC_ID NUMBER(10,0),
	FORUM_ID NUMBER(10,0) NOT NULL,
	USER_ID NUMBER(10) NOT NULL,
	POST_TIME DATE,
	LAST_EDIT_TIME DATE,
	STATUS NUMBER(1),
	PERMA_LINK VARCHAR2(255) NOT NULL,
	PRIMARY KEY (ID)
);


CREATE TABLE F_POST_DETAILS
(
	ID NUMBER(10,0) NOT NULL,
	TEXT BLOB,
	SUBJECT VARCHAR2(4000),
	PRIMARY KEY (ID)
);


CREATE TABLE F_TOPIC
(
	ID NUMBER(10,0) NOT NULL,
	FORUM_ID NUMBER(10,0) NOT NULL,
	USER_ID NUMBER(10),
	TITLE VARCHAR2(256),
	CREATE_TIME DATE,
	STATUS NUMBER(1),
	ANS_POST_ID NUMBER(10,0),
	PUSH_TO_BUG_TOOL NUMBER(1),
	BOUNTY_VALUE NUMBER(10,0),
	PRIMARY KEY (ID)
);


CREATE TABLE F_USER
(
	ID NUMBER(10) NOT NULL,
	USERNAME VARCHAR2(64) NOT NULL UNIQUE,
	PASSWORD VARCHAR2(32),
	REGISTRATION_DATE DATE,
	-- There can be 10 level 0-9
	STATUS NUMBER(1),
	EMAIL VARCHAR2(128) UNIQUE,
	BOUNTY_VALUE NUMBER(10,0),
	PRIMARY KEY (ID)
);


CREATE TABLE F_USER_GROUP
(
	USER_ID NUMBER(10) NOT NULL,
	GROUP_ID NUMBER(10,0) NOT NULL,
	UNIQUE (USER_ID, GROUP_ID)
);


CREATE TABLE F_VOTE
(
	-- Not sure about this field. just kept to track it
	ID NUMBER(10,0),
	-- This field will keep track of the topic upvotes
	-- 
	TOPIC_ID NUMBER(10,0),
	-- This field will keep track of the post upvotes
	POST_ID NUMBER(10,0),
	USER_ID NUMBER(10) NOT NULL,
	-- This will be like NPS default null. +1 = upvote while -1 is downvote
	VALUE NUMBER(1,0)
);



/* Create Foreign Keys */

ALTER TABLE F_CATEGORY
	ADD CONSTRAINT CATEGORY_PARENT_ID FOREIGN KEY (PARENT_ID)
	REFERENCES F_CATEGORY (ID)
;


ALTER TABLE F_FORUM
	ADD FOREIGN KEY (CATEGORY_ID)
	REFERENCES F_CATEGORY (ID)
;


ALTER TABLE F_POST
	ADD FOREIGN KEY (FORUM_ID)
	REFERENCES F_FORUM (ID)
;


ALTER TABLE F_TOPIC
	ADD FOREIGN KEY (FORUM_ID)
	REFERENCES F_FORUM (ID)
;


ALTER TABLE F_GROUP
	ADD FOREIGN KEY (PARENT_ID)
	REFERENCES F_GROUP (ID)
;


ALTER TABLE F_USER_GROUP
	ADD FOREIGN KEY (GROUP_ID)
	REFERENCES F_GROUP (ID)
;


ALTER TABLE F_ATTACHMENT
	ADD FOREIGN KEY (POST_ID)
	REFERENCES F_POST (ID)
;


ALTER TABLE F_POST_DETAILS
	ADD FOREIGN KEY (ID)
	REFERENCES F_POST (ID)
;


ALTER TABLE F_VOTE
	ADD FOREIGN KEY (POST_ID)
	REFERENCES F_POST (ID)
;


ALTER TABLE F_POST
	ADD FOREIGN KEY (TOPIC_ID)
	REFERENCES F_TOPIC (ID)
;


ALTER TABLE F_VOTE
	ADD FOREIGN KEY (TOPIC_ID)
	REFERENCES F_TOPIC (ID)
;


ALTER TABLE F_POST
	ADD FOREIGN KEY (USER_ID)
	REFERENCES F_USER (ID)
;


ALTER TABLE F_TOPIC
	ADD FOREIGN KEY (USER_ID)
	REFERENCES F_USER (ID)
;


ALTER TABLE F_USER_GROUP
	ADD FOREIGN KEY (USER_ID)
	REFERENCES F_USER (ID)
;


ALTER TABLE F_VOTE
	ADD FOREIGN KEY (USER_ID)
	REFERENCES F_USER (ID)
;



/* Create Triggers */

CREATE TRIGGER TRI_CATEGORY_CATEGORY_ID BEFORE INSERT ON CATEGORY
FOR EACH ROW
BEGIN
	SELECT SEQ_CATEGORY_CATEGORY_ID.NEXTVAL
	INTO :NEW.CATEGORY_ID
	FROM DUAL;
END;
CREATE TRIGGER TRI_CATEGORY_ID BEFORE INSERT ON CATEGORY
FOR EACH ROW
BEGIN
	SELECT SEQ_CATEGORY_ID.NEXTVAL
	INTO :NEW.ID
	FROM DUAL;
END;
CREATE TRIGGER TRI_CY_FORUM_CATEGORY_ID BEFORE INSERT ON CY_FORUM_CATEGORY
FOR EACH ROW
BEGIN
	SELECT SEQ_CY_FORUM_CATEGORY_ID.NEXTVAL
	INTO :NEW.ID
	FROM DUAL;
END;
CREATE TRIGGER TRI_FORUMS_ID BEFORE INSERT ON FORUMS
FOR EACH ROW
BEGIN
	SELECT SEQ_FORUMS_ID.NEXTVAL
	INTO :NEW.ID
	FROM DUAL;
END;
CREATE TRIGGER TRI_FORUM_CATEGORY_ID BEFORE INSERT ON FORUM_CATEGORY
FOR EACH ROW
BEGIN
	SELECT SEQ_FORUM_CATEGORY_ID.NEXTVAL
	INTO :NEW.ID
	FROM DUAL;
END;
CREATE TRIGGER TRI_POST_ID BEFORE INSERT ON POST
FOR EACH ROW
BEGIN
	SELECT SEQ_POST_ID.NEXTVAL
	INTO :NEW.ID
	FROM DUAL;
END;



/* Create Indexes */

CREATE UNIQUE INDEX CY_FORUM_CATEGORY_ID_IDX ON F_CATEGORY USING BTREE (ID);
CREATE INDEX FORUM_CATEGORY_ID_IDX ON F_FORUM USING BTREE (CATEGORY_ID);
CREATE INDEX GROUP_PARENT_ID_IDX ON F_GROUP USING BTREE ();



/* Comments */

COMMENT ON COLUMN F_CATEGORY.ID IS 'This table defines the base categories of the forum';
COMMENT ON COLUMN F_CATEGORY.TITLE IS 'The title of the category';
COMMENT ON COLUMN F_CATEGORY.DISPLAY_ORDER IS 'the order of the categories in the home page';
COMMENT ON COLUMN F_CATEGORY.PARENT_ID IS 'This table defines the base categories of the forum';
COMMENT ON COLUMN F_FORUM.CATEGORY_ID IS 'This table defines the base categories of the forum';
COMMENT ON COLUMN F_USER.STATUS IS 'There can be 10 level 0-9';
COMMENT ON COLUMN F_VOTE.ID IS 'Not sure about this field. just kept to track it';
COMMENT ON COLUMN F_VOTE.TOPIC_ID IS 'This field will keep track of the topic upvotes';
COMMENT ON COLUMN F_VOTE.POST_ID IS 'This field will keep track of the post upvotes';
COMMENT ON COLUMN F_VOTE.VALUE IS 'This will be like NPS default null. +1 = upvote while -1 is downvote';



