rem
rem --- Dette script kræver at, følgende tre installationsfiler findes i samme mappe som scriptet. 
rem
rem     Installationsfil for PostgreSQL ver 13: postgresql-13.4-2-windows-x64.exe. kan downloades fra: https://content-www.enterprisedb.com/postgresql-tutorial-resources-training?cid=437
rem 
rem     Installationsfil for PostGIS ver. 3.1: postgis-bundle-pg13x64-setup-3.1.4-1.exe. Kan downloades fra http://download.osgeo.org/postgis/windows/pg13/postgis-bundle-pg13x64-setup-3.1.4-1.exe
rem

rem ---- Password og Portnummer og installationsmappe for PostgreSQL kan aendres ---

rem --- Password for postgres superuser, standard er: ukulemy
set pg_pass=ukulemy

rem --- Portnummer for PostgreSQL, standard er 5432
set pg_port=5432

rem --- Installation mappe for Postgres. Lad vaere med at pille ved den - undtaget hvis du absolut ved, hvad du goer!! Standard er: C:\Program Files\PostgreSQL\13 
set pg_dir=C:\Program Files\PostgreSQL\13


rem --- Resten maa ikke aendres ---
set pgs_inst=%0\..\postgresql-13.4-2-windows-x64.exe
set pgi_inst=%0\..\postgis-bundle-pg13x64-setup-3.1.4-1.exe

set pg_dir=C:\Program Files\PostgreSQL\13
%pgs_inst% --mode unattended --unattendedmodeui minimalWithDialogs --superpassword %pg_pass% --serverport %pg_port% --prefix "%pg_dir%" --datadir "%pg_dir%\data" 
%pgi_inst% /S /D=%pg_dir%
