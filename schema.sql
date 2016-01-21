\c mythical_db_test

DROP TABLE IF EXISTS users;

CREATE TABLE users (
id SERIAL PRIMARY KEY,
email VARCHAR UNIQUE NOT NULL,
username VARCHAR NOT NULL,
password_digest VARCHAR NOT NULL
)