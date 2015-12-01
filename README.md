# moosex-storage-dbi-pgdoc
Extend MooseX::Storage to allow storing objects in PostgreSQL as JSON

Requirements:
- Your object must have 'uuid' method (that should return a valid UUID string)
- A DBI database handler must be passed when storing/loading objects
- Load requires a UUID for the object you want to load (it is the identifier)
- DB schema in Postgres (this was used during development):
    - two columns: uuid (type uuid), json (type jsonb)
    - primary key: uuid

Future versions (feedback is greatly appreciated):
- Remove assumption of JSON (verify that it is)
- Allow specifying a subroutine or a name for the table (allow this to do table per class)
- Possibly create tables if needed? (feedback would be appreciated)
- Verify DB schema being compatible?
- Cache/store (or use a callback?) for DB handler to allow objects to change what DB to save in (and remove the requirement of the handler for the store)
