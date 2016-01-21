\c mythical_db_test



CREATE TABLE users (
id SERIAL PRIMARY KEY,
username VARCHAR UNIQUE NOT NULL,
password_digest VARCHAR NOT NULL
)

CREATE TABLE topics(
id SERIAL PRIMARY KEY,
topic VARCHAR,
user_id INTEGER REFERENCES users(id) 
)

CREATE TABLE comments(
id SERIAL PRIMARY KEY,
comment VARCHAR,
user_id INTEGER REFERENCES users(id),
topic_id INTEGER REFERENCES topics(id)
)



