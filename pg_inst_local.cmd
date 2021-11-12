rem
rem --- Dette script kræver at, følgende tre installationsfiler findes i samme mappe som scriptet. 
rem
rem     Installationsfil for PostgreSQL ver 13: postgresql-13.5-1-windows-x64.exe. kan downloades fra: https://content-www.enterprisedb.com/postgresql-tutorial-resources-training?cid=437
rem 
rem     Installationsfil for PostGIS ver. 3.1: postgis-bundle-pg13x64-setup-3.1.4-1.exe. Kan downloades fra http://download.osgeo.org/postgis/windows/pg13/postgis-bundle-pg13x64-setup-3.1.4-1.exe
rem
rem --- Ved skift til ny *hoved* version af PostgreSQL, eks. fra ver. 13 til ver. 14. Skal alle environment variable "pg_dir", "pgs_inst" og "pgi_inst" rettes nede i scriptet
rem     Ved skift til en ny del-version, eks. fra 13.4 til 13.5  er det kun environment variable "pgs_inst" og/eller "pgi_inst", der skal rettes.  

rem --- Password for postgres superuser, standard er: ukulemy
set pg_pass=ukulemy

rem --- Portnummer for PostgreSQL, standard er 5432
set pg_port=5432

rem --- Installation mappe for Postgres. Lad vaere med at pille ved den - undtaget hvis du absolut ved, hvad du goer!! Standard er: C:\Program Files\PostgreSQL\13 
set pg_dir=C:\Program Files\PostgreSQL\13

rem --- Navnet paa installationsfil for PostgreSQL. Denne kan skifte, hvis når den kommer nye versioner af PostgreSQL. 
rem --- Filnavnet vil saa aendre sig. Og dette navn skal rettes paa nedenstaaende linje (efter de første "%0\..\")
set pgs_inst=%0\..\postgresql-13.5-1-windows-x64.exe

rem --- Navnet paa installationsfil for PostGIS. Denne kan skifte, hvis når den kommer nye versioner af PostGIS. 
rem --- Filnavnet vil saa aendre sig. Og dette navn skal rettes paa nedenstaaende linje (efter de første "%0\..\")
set pgi_inst=%0\..\postgis-bundle-pg13x64-setup-3.1.4-1.exe

set pg_dir=C:\Program Files\PostgreSQL\13
%pgs_inst% --mode unattended --unattendedmodeui minimalWithDialogs --superpassword %pg_pass% --serverport %pg_port% --prefix "%pg_dir%" --datadir "%pg_dir%\data" 
%pgi_inst% /S /D=%pg_dir%
