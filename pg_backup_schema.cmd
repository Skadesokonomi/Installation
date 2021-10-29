@echo off
REM ==== Simpel backup procedure til backu af individuelle schemaer i en postgres database

REM Proceduren benytter 3 paramtre
REM parm. 1: Navnet paa databasen (uden "), eks. flood_damae_costs
REM parm. 2: Navnet paa schema (uden "), eks. fdc_data
REM parm. 3: Navnet paa mappe, hvor backup skal placeres (uden " og uden sidste \), eks. d:\backupdata 

REM Proceduren genererer selv filnavnet, som bliver et 4-leddet navn adskilt af punktum: database-navn . schema-navn . timestamp . backup
REM Timestamp genereres automatisk. De oevrige elementer findes i paramtrene til proceduren

REM ==== Nedenstaaende environment variable saettes permanent op for den givne system foer brug af procedure===

REM Det fulde sti+navn for pg_dump programmet (uden " rundt om)
set dmp_prog=C:\Program Files\PostgreSQL\13\bin\pg_dump.exe

REM Host navn for database server, normalt localhost 
set PGHOST=localhost
REM Port nummer for database server, normalt 5432 
set PGPORT=5432
REM Postgres username, som benyttes til backup
set PGUSER=xxxx
REM Password til postgres user
set PGPASSWORD=xxxx

REM ==== Ret ikke nedenfor denne linje =====
set PGDATABASE=%1
set dmp_schema=%2
set dmp_path=%3

set PGDATABASE=%PGDATABASE:"=%
set dmp_schema=%dmp_schema:"=%
set dmp_path=%dmp_path:"=%

set tstmp=%date:~6,4%_%date:~3,2%_%date:~0,2%_%time:~0,2%_%time:~3,2%_%time:~6,2%

"%dmp_prog%" --file "%dmp_path%\%PGDATABASE%.%dmp_schema%.%tstmp%.backup" --verbose --format=c --blobs --no-owner --no-privileges --no-tablespaces --no-unlogged-table-data --no-comments --schema "%dmp_schema%"

