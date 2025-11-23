@echo on
set PGDATABASE=fdc_andeby
set PGUSER=postgres
set PGHOST=localhost
set PGPORT=5432

:tst13
if not exist "C:\Program Files\PostgreSQL\13\bin\pg_restore.exe" goto tst14
"C:\Program Files\PostgreSQL\13\bin\pg_restore.exe" --dbname "%PGDATABASE%" --verbose "fdc_andeby.backup"
goto slut

:tst14
if not exist "C:\Program Files\PostgreSQL\14\bin\pg_restore.exe" goto tst15
"C:\Program Files\PostgreSQL\14\bin\pg_restore.exe" --dbname "%PGDATABASE%" --verbose "fdc_andeby.backup"
goto slut

:tst15
if exist "C:\Program Files\PostgreSQL\14\bin\pg_restore.exe" "C:\Program Files\PostgreSQL\15\bin\pg_restore.exe" --dbname "%PGDATABASE%" --verbose "fdc_andeby.backup"

:slut

pause
