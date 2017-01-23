-- cat app-schema.sql | sqlite3 app.db
-- dbicdump -o dump_directory=lib App::Mook::Schema dbi:SQLite:dbname=app.db

BEGIN;

DROP TABLE IF EXISTS user;

CREATE TABLE user (
  id   TEXT PRIMARY KEY NOT NULL
, pass TEXT             NOT NULL
);

DROP TABLE IF EXISTS note;

CREATE TABLE note (
  id      INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
, title   TEXT                              NOT NULL
, content TEXT                              NOT NULL
, user_id TEXT                              NOT NULL REFERENCES user ( id )
);

COMMIT;
