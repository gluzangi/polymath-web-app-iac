/* --------------------------------------------- */ 
/* AUTOMATICALLY IMPORT SCHEMAS DURING DB LAUNCH */
/* --------------------------------------------- */ 

/* Extension For Password Encryption And Randomized UUID Gen*/
CREATE EXTENSION IF NOT EXISTS pgcrypto;

/* DB Namespace For db_crypto */
/* DROP DATABASE IF EXISTS db_crypto; */
/* CREATE DATABASE db_crypto; */

/* Schema For tbl_users */
CREATE TABLE IF NOT EXISTS tbl_users (
  user_id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_name TEXT NOT NULL,
  user_address TEXT NOT NULL,
  user_country TEXT NOT NULL,
  user_phone JSONB NOT NULL,
  user_phone_verified_at TIMESTAMP,
  user_email TEXT NOT NULL,
  user_email_verified_at TIMESTAMP,
  user_crypto_accounts JSONB,
  user_password TEXT NOT NULL,
  user_create_at TIMESTAMP,
  user_update_at TIMESTAMP,
  UNIQUE(user_email)
);

/* Comment For Table: tbl_users */
COMMENT ON TABLE tbl_users IS 'Registered Users KYC Info';
/* Comment For Column: user_phone */
COMMENT ON COLUMN tbl_users.user_phone IS 'Key-Value Pair Of MNO And User Phone Number(s) Starting With Country_Code Followed By MNO_Provider';
/* Comment For Column: user_crypto_accounts */
COMMENT ON COLUMN tbl_users.user_crypto_accounts IS 'Key-Value Pair Of Cryptocurrency/Token And Public Key';
