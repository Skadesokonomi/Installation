# Installationsvejledning til QGIS plugin "Skadesøkonomi"
OBS! NEDENSTÅENDE VEJLEDNING ER IKKE LÆNGERE GÆLDENDE 

SE I STEDET VIDEOVEJLEDNING NR 1 (FINDES I MAPPEN DOKUMENTATION OG VEJELDNINGER) ELLER DOKUMENTET "skadesøkonomi Initiel installation.docx" FOR INFORMATION OM HVORDAN MAN INSTALLERER OS2-SkadesØkonomi

Følgende forudsætninger gælder for installation af og brug af plugin "Skadesøkonomi":

- Kan kun benyttes med **QGIS ver. 3.20 eller nyere**. QGIS versioner ældre end ver 3.20 har ikke den nødvendige support for visse Python funktioner og vil derfor give kørselsfejl ved opstart af plugin. Desuden har ældre QGIS problemer med at - via Python - at tilknytte alfanumeriske
(ikke-spatielle) tabeller som lag i QGIS.
 
- Til permanent opbevaring af data for plugin kræves en installation af **PostgreSQL ver. 13 eller nyere**. 

- Til spatiel databehandling i PostgreSQL databasen kræves en installation af **PostGIS ver. 3.1 eller nyere**. Denne - eller nyere - versioner indeholder funktioner til mere robust behandling af polygon overlay end tidligere versioner. 

## Anskaffelse af installationsfiler til plugin.

- I en web-browser navigerer man til http adresse: https://github.com/Skadesokonomi/Installation

- I skærmbilledet trykker man på den grønne knap "Code", hvorefter der vises en undermenu.

- I undermenuen trykkes på valg "Download ZIP", som igansætter en download af fil "Installation - main.zip"

- Efter download er færdig, udfoldes zip-filen på et vilkårligt sted i brugerens filsystem.

## Manuel installation af PostgreSQL database systemet.

Hvis man allerede har en PostgreSQL / PostGIS installation der opfylder ovenstående krav, kan man springe dette afnit over og gå direkte til afsnit *Opsætning af database på PostgreSQL server til brug for plugin "Skadesøkonomi"*

Hvis man accepterer predefinerede valg for hhv. PostgreSQL superuser password, portnummer for database samt installationsmappe for databaseprogrammer - eller skal man gennemføre denne installation på flere pc'er - kan man hoppe til afsnit 
*Automatiseret installation af PostgreSQL, PostGIS og PGAdmin4*

NB! Alle installationer, både manuelle og automatiske kræver at den benyttede windows bruger har "local admin" rettigheder på pc'en, så brugeren er i stand til at installere programmer på pc'en (!). 

Brug hjemmesiden her, men bemærk forskellene listet herunder: https://www.postgresqltutorial.com/install-postgresql/

Der er nogle forskelle fra ovenstående installationsvejledning:

- Brug den seneste version af (pt. ver. 15.3) af PostgreSQL.

- Husk port nummer (normalt 5432). Det skal du bruge, når du opsætter forbindelsen mellem QGIS og PostgreSQL.

- Husk det password, du indtaster. Dette er passwordet til PostgreSQL superbruger "postgres". Username og password skal senere bruges til forbinde QGIS og PostgreSQL, så husk både username og password.

- Sæt et flueben ved Stack Builder i Skærmbillede "Select components". Efter den almindelige installation af PostgreSQL vil det starte programmet "StackBuilder" som giver dig mulighed for at installere PostGIS.


## Manuel installation af PostGIS extension

Efter installationen af PostgreSQL er det nødvendigt at supplere med en ekstar installation af PostGIS. PostGIS er en udvidelse til PostgreSQL, som giver den mulighed for at behandle spatielle data.

Brug hjemmesiden her https://postgis.net/workshops/postgis-intro/installation.html , men bemærk instruktionerne herunder: 

- Vælg PostgreSQL server instans - typisk: "PostgreSQL 15 (x64) on port 5432" - og tryk på knap "Next"

- I det nye skærmbillede: Udfold gren "Spatial extensions" og sæt "hak" ved den nyeste version af PostGIS (pt. ver. 3.3).

- Acceptér alle standard valg og div. spørgsmål om miljøvariable (Environment variables)


## Automatiseret installation af PostgreSQL, PostGIS og PGAdmin4

NB! Vi er ved at opdatere denne metode, således den installerer sidste nye version af PostgreSQL/PostGIS. Så brug **ikke** denne metode, hvis du ønsker den nyeste version fa databasesystemet

Installationsdata fra GitHub indeholder et DOS-script "pg_inst_local.cmd". Dette script vil automatisk installere PostgreSQL, PostGIS og PGAdmin4 administrationsværktøjet.

Ved brug af scriptet bliver visse parametre er fastlagt:

- Scriptet installerer PostgreSQL ver. 13.4, PostGIS ver 3.2.3-1 og PGAdmin4 ver. 4.4

- Password er for postgres superuser er sættes til "ukulemy" og postgreSQL portnr. sættes til 5432

- Installations mappe for PostgreSQL sættes sat til "C:\Program Files\PostgreSQL\13"
 
Alle disse parametre kan dog ændres ved at tilpasse/redigere scriptet før kørsel. Tilpasning af de enkelte parametre er dokumenteret i kildeteksten for scriptet.

Installationen foretages på følgende måde:

- Før kørsel skal installationsfil for PostgreSQL ver. 13.5: "postgresql-13.5-1-windows-x64.exe" downloades fra https://content-www.enterprisedb.com/postgresql-tutorial-resources-training?cid=437 og placeres i samme mappe som "pg_inst_local.cmd"
                                                                                                     
- Før kørsel skal  installationsfil for PostGIS ver. 3.2: "postgis-bundle-pg13x64-setup-3.2.3-1.exe" downloades fra http://download.osgeo.org/postgis/windows/pg13/postgis-bundle-pg13x64-setup-3.2.3-1.exe og placeres i samme mappe som "pg_inst_local.cmd"

- Med stifindes navigeres til mappen med "postgresql-13.5-1-windows-x64.exe", "postgis-bundle-pg13x64-setup-3.2.3-1.exe" og "pg_inst_local.cmd"

- Der *højreklikkes* på fil: "pg_inst_local.cmd"

- I undermenuen klikkes på "Kør som administrator". Herefter starter scriptet. Det er færdigt i løbet af 1 - 3 minutter.

NB!! Fra tid til anden vil download linket, som henter installationsfilen (pt.: postgresql-13.5-1-windows-x64.exe) fra EnterpriseDB's hjemmeside **skifte** versionsnummer på den postgreSQL som hentes, eks. fra ver 13.4 til ver. 13.5. Når det sker, skifter navnet på den hentede installationsfil. 

Er dette tilfældet, vil kommandoproceduren "pg_inst_local.cmd" **ikke** fungere før denne er rettet mht. det nye filnavn.
Dette gøres med en simpel tekst editor såsom Notesblok. Selve rettelsen er ganske simpel **og er beskrevet i selve kommandoproceduren**. 


## Opsætning af PGAdmin4 administrationsværktøj

NB! Denne opsætning vejledning er **overflødig**, hvis du har installeret ver 15.x af PostgreSQL, fordi opsætning foretages automatisk under selve installationen.  

PGAdmin4 administrationsværktøj installeres automatisk sammen med PostrgreSQL. Men det kræver en del opsætning før det kan benyttes til administration. Du skal gøre følgende:

- Start PGAdmin4 op. Det befinder sig under Windows start, gruppe: "PostgreSQL 13" (eller evt. 14, hvis du har installer denne versaion af PostgreSQL).

- Ved første opstart vil PGAdmin4 bede dig om at opsætte et adgangskode til PGAdmin4, som du skal indtaste i et tekstfelt. Du kan evt. vælge at bruge det samme adgangskode (password), som er benyttet til postgres user, men det kan også være et vilkårligt password. Hver gang du herefter starter PGAdmin4 op skal du indtaste denne adgangskode for at kunne benytte PGAdmin4.

For at kunne benytte PGAdmin til backup og/eller restore kræves det, at PGAdmin kan finde de relevante stand-alone programmer til disse formål. Det gøres på følgende måde:

- Start PGAdmin4 op og indtast adgangskode.

- Klik menupunkt: "File" -> "Preferences". Der vises en ny brugerskærmbillede

- I venstre del af dette skærmbillede klikkes på -> "Paths" -> "Binarypaths"

- I højre del af skærmbilledet scrolles ned til sektion "PostgreSQL Binary Path".

- Find den række i sektionen, som svarer til den version af PostgreSQL, du har installeret. Det er sandsynligvis værdien "PostgreSQL 13" i kolonne "Database server".

- I samme række, kolonne "Binary path" indtatestes mappenavnet "C:/Program Files/PostgreSQL/13/bin", som er den mappe, som indeholder alle administartionsprogrammer til PostgreSQL. Hvis det er PostgreSQL ver. 13, som er installeret bliver mappenavnet "C:/Program Files/PostgreSQL/14/bin"

- I samme række, kolonne "Set as default" aktiveres valget med at trykke knappen ind, så den bliver farven blå.

- Opsætningen afsluttes ved at trykke på knap "Save" i nederste højre hjørne af skærmbilledet.

For at aktivere den relevante server gæres følgende:

- Start PGAdmin4 op og indtast adgangskode.

- I venstre side, øverst, trykkes på blad "Servers" for at folde det ud.

- Den relevante server (der er muligvis kun en, sandsynligvis ved navn "PostgreSQL 13" eller "PostgreSQL 14") markeres.
Første gang, man aktiverer en server med ovenstående metode anmodes man om at angive password for super bruges postgres. Password for denne bruger indatstes i indtastniingsfeltepræsenteres man for en
 
## Opsætning af database på PostgreSQL server til brug for plugin "Skadesøkonomi"

Dette afsnit beskriver, hvorledes man opretter en ny database til brug for plugin - inklusive opsætning og navngivning af
database, diverse schemaer samt placering og navngivning af specifikke opslagstabeller til styring af plugin. 

Data i parametertabellen er tilpasset de medfølgende eksempeldata.
 
Dette er ikke *absolut* nødvendigt at installere eksempeldata og/eller følge denne vejledning mht. til placering og navngivning, 
men det anbefales at den initielle opsætning inkluderer installationen af eksempeldata og at man ikke umiddelbart ændrer opsætningsparametre.

Dette giver brugeren mulighed for at teste systemet med kendte data før import af egne data samt tilpasning af opsætning af systemet til disse.

### Oprettelse af database til "Skadesøkonomi" Plugin

Dette afsnit kan springes over, hvis der allerede findes en database på databaseserveren til brug for Skadesøkonomi plugin.

- Start PGAdmin4 op og indtast adgangskode.

- I venstre side, øverst, trykkes på blad "Servers" for at folde det ud.

- Den relevante server (der er muligvis kun en, sandsynligvis ved navn "PostgreSQL 13", "PostgreSQL 14" eller "PostgreSQL 15") markeres.

- Der højreklikkes og i den viste undermenu vælges menupunkt: "Create" -> "Database". Der vises et nyt skærmbillede: "Create - Database"

- I dette skærmbillede, faneblad "General", indtastningsfelt "Database" indtastes det ønskede databasenavn. Navnet kan være vilkårligt, men det _anbefales_ at holde sig til små bogstaver a-z samt undescore og undgå æøå, blanktegn osv.

- Database oprettelse afsluttes ved at trykke på knap "Save" i nederste højre hjørne af skærmbilledet.

### Oprettelse af schemaer samt administrationstabeller

- Start PGAdmin4 op og indtast adgangskode.

- Markér og udfold blad "Servere" og dernæst den relevante server (sandsynligvis "PostgreSQL 13")

- Marker og udfold blad "Databases" og dernæst den relevante database, hvor scriptyet skal oprette schemaerne.

- Klik på menupunkt "Tools" -> "Query tool". I højre side af skærmbilledet er der nu er query vindue hvori du kan skrive sql kommandoer.

- Tast Alt-O. PGAdmin4 viser en "Åbn-fil" dialog.

- i dialogen navigérer du til mappen med indhold fra GitHub zip-filen og dobbeltklikkerpå fil: "fdc_script_new_database.sql". Indholdet af filen vises nu i query-vinduet.

- Udfør kommandoerne i scriptet ved at trykke på tast F5. Scriptet vil gøre følgende:

    - Oprette 3 schemaer "fdc_admin", "fdc_data" og "fdc_results" (og evt slette eksisterende schemaer og indhold med samme navn)

    - Oprette 4 tabeller i schema: "fdc_admin" og indsætte data i disse tabeller: "bbr_anvendelse", "kvm_pris", "parametre", "skadesfunktioner"

### Indlæsning af testdata til Skadesøkonomi - KAN PT. IKKE BENYTTES

NB! Testdata er indtil videre fjernet fra installationen, så dette afsnit er kun til reference

Zip-filen hentet fra GitHub indeholder et sæt at testdata, som supplerer opsætningen indlagt ved udførelsen af ovenstående script. 
Hvis testdata indlæses, haves et komplet og fungerende system, som kan benyttes af bruger og administrator til at øve sig på.

Vejledningen benytter PGAdmin4 som administrationsværktøj:

- Start PGAdmin4 op og indtast adgangskode.

- Markér og udfold blad "Servere" og dernæst den relevante server (sandsynligvis "PostgreSQL 13")

- Marker og udfold blad "Databases" og dernæst den relevante database.

- Marker og udfold blad "Schemas" og find derefter schema "fdc_data"

- Højreklik på schema "fdc_data" og klik på punkt "Restore" i undermenuen. Der vises et nyt skærmbillede: "Restore (schema: fdc_data)"

- I skærmbilledet, Faneblad "General", valgliste "Format" vælges "Custom or tar"

- I skærmbilledet, Faneblad "General", filvælger "Filename" findes den mappe, hvor GitHub zip-filen blev udfoldet i. 

- I denne mappe vælges fil "fdc_data.backup"

- Der trykkes på knap "Restore" og testdata indlæses.

- I schema "fdc_data" kan man indlægge eksempeldata fra backup fil: "fdc_data.backup" i den den dowbloadede zip-fil. Dette anbefales, fordi denne restore vil oprette en række datatabeller i schemaet, så oplysninger (data) i parameter tabellen stemmer overens med tabel navne og indhold i schema "fdc_data". 

Efter installationen af plugin "Skadesokonomi" kan man afprøve plugin'et med det samme, fordi databasen vil være sat op med testdata samt en korret opsætning for disse testdata.
 

## Installation af plugin i QGIS

1. Start QGIS

2. Vælg menupunkt "Plugins" -> "Administrér og Installér plugins..." -> (Lodret) Faneblad "Installér fra ZIP"

3. I det viste brugerskærmbillede "Plugins | Installér fra ZIP", felt: "ZIP fil:" Indtastes det fulde sti- og filnavn for zip-filen "ecomodel.zip", som er inkluderet i den hentede zip "installation - main.zip" fra GitHub.
Man kan også benytte knappen umiddelbart til højre for indtastningsfeltet for at få vist et skærmbillede til at vælge zip filen.

4. Man afslutter installationen ved at trykke på knap "Installér Plugin" 

## Første gangs opsætning af plugin i QGIS

Før brug skal plugin forbindes til Postgres databasen som indeholder schemaer og tabeller til "Skadesøkonomi".
Dette gøres med følgende:

1. Start QGIS 

2. I Datakilde håndtering" / "Data source Manager" (**Ctrl-L**), faneblad "PostgreSQL" skal der oprettes en forbindelse til databasen med data til "Skadesøkonomi". 

    Sæt flueben ved "Gem" for hhv. brugernavn og adgangskode til forbindelse. 
    Husk navnet på forbindelsen

3. Start "Skadesøkonomi" plugin vha. menupunkt: "Plugins" --> "Skadeøkonomi" -->  "Vis skærmbillede"

4. Ved første opstart vises der sandsynligvis en fejlmeddelelse: "**EcoModel : Database forbindelse eller parametertabel ikke værdisat**". 
Dette skyldes, at plugin'et ikke initielt er sat op til at benytte den korrekte database forbindelse. Man retter dette med følgende:

    1. Tryk på knap "Administration" (nederst til højre i plugin skærmbillede).  Der vises tre ekstra faneblade "Generelt", "Forespørgsler" og  "Data".

	2. Aktivér faneblad "Generelt"

	3. I faneblad "Generelt", afsnit "Databasekilde", drop-down valgliste for felt "Database" vælges databaseforbindelsen for "Skadeøkonomi" data, som du oprettede umidelbart før opstart af plugin.

	4. I tekstfelt "Parameter tabel" skrives navnet - inklusive schemanavn - for tabellen med parameter data, f.eks. "fdc_admin.parametre" (Hvis man har benyttet installations script for schemaer samt administrationstabeller og foretaget en restore af ekempeldata i schema fdc_data er det ikke nødvendigt at foretage ændringer i dette felt). 

	5. Tryk på knap "Genindlæs parametre" (nederst i midten i plugin skærmbillede)
	
        De forskellige faneblade fyldes nu med oplysninger og data. Systemet husker dine indtastninger, så der ikke forekommer fejl ved næste opstart.

    6. Tryk på knap "Administration" igen. De tre ekstra faneblade "Generelt", "Forespørgsler" og  "Data" forsvinder.

Nu er systemet klart til afprøvning
	
## Simpel backup procedure til at sikkerhedskopiere schemaer med tabeller eller hele databasen til en specifik mappe

zip filen fra GitHub indeholder 1 DOS kommmando-procedure samt 2 eksempel kommandoprocedurer som kan foretage sikkerhedskopiering af de forskellige database schemaer eller hele databasen
 
 - "pg_backup.cmd", som er selve backup proceduren. Proceduren benytter sig af backup programmet pg_dump.exe, som følger med alle postgres installationer. 
     Der er en række parametre i denne procedure, som skal tilpasses det specifikke system. Alle parametre er dokumenteret direkte i proceduren, som kan redigeres med en simpel tekst editor, f.eks. NotePad
 
 - "pg_backup_schema_example.cmd", er et eksempel på, hvorledes backup proceduren bliver aktiveret for specifikke schemaer. Denne kommandoprocedure er også selv-dokumenterende.

 - "pg_backup_database_example.cmd", er et eksempel på, hvorledes backup proceduren bliver aktiveret for hele databasen. Denne kommandoprocedure er også selv-dokumenterende.
 
 Opsætning foregår som følger: 
 
 - De 3 procedurer kopieres til et vilkårlig placering på pc eller netværket. De skal placeres i samme mappe for at fungere korrekt. 
 
 - Computeren, som skal udføre backup, skal have adgang til mapper til opbevaring af backup data, mappen med de 3 procedurer samt mappen med pg_dump.exe
 
 - pg_backup.cmd redigeres, så parametrene vedr. hostname, portnummer, databasenavn, database bruger, password samt placering af postgres pg_dump.exe er sat korrekt op. 
 
 - pg_backup_schema_example.cmd redigeres således databasenavn, schemanavne samt mappe for backupfilerne er korrekte. Selve navnet på filen kan også rettes. 

 - pg_backup_database_example.cmd redigeres således databasenavn samt mappe for backupfilen er korrekte. Selve navnet på filen kan også rettes. 
 
 
Selve proceduren kan udføres manuelt: Via Stifinder dobbeltklikkes på den rettede pg_backup_schema_example.cmd. Herefter foretages backuppen.

Man kan alternativt opsætte udføreslen i Windows opgave styring. Her skal man aktivere "pg_backup_schema_example.cmd" eller "pg_backup_schema_example.cmd" uden andre parametre. 


## Noter vedrørende opsætning af serverbaseret udgave af PostgreSQL

Den ovenstående installationsdokumentation for PostgreSQL kan også benyttes når PostgreSQL skal installeres på en server

Men der er en række ekstra skridt, der skal gennemføres at PostgreSQL fungerer godt i et server miljø.

### Dimensionering af server.

Et godt idgangspunkt for dimensionering af en (virtuel) server:

 - 2 CPU
 - 16 GB Ram.
 - 2 HDU : 100 GB Harddisk til operativsystem plus selve installationen af PostgreSQL samt 100 GB Harddisk til PostgreSQL datamappe og importdata

Hvis det viser sig, at PostgreSQL ikke abejder hurtigt nok, kan IT afdelingen - hvis server er virtuel - hurtigt rekonfigurere til en større maskine

### Installation af PostgreSQL

Hvis man har 2 harddiske til rådighed og ønsker at placere database-data på en anden harddisk end program/operativsystemet harddisken
 er det nødvendigt at bruge den manuelle installationsmetode for PostgreSQL. Under installationen giver denne metoide dig mulighed for at vælge "data-directory"

### Opsætning af operativsystem

Postgres bruger port 5432 til netværkskommunikation mellem postgresql server og -klienter. 
Så det er nødvendigt at åbne for denne port i Firewall.

### Netværksopsætning af PostgreSQL

PostgreSQL er som default sat op til *ikke* at kommunikere med andre end lokale klienter 
(dvs. programmer installeret på samme maskine som PostgreSQL) 

Der skal ændres en række opsætninger i to opsætningsfiler placeret i mappe: C:\Program Files\PostgreSQL\13\data ("13" skal udskiftes med hoved versionsnummer for den installerede PostgreSQL)

Man skal redigere i de to opsætningsfiler med en alm teksteditor, f.eks. NotePad.

I fil "postgresql.conf" findes linjen som *starter* med 
```
listen_addresses = 
```
Denne ændres til 

```
listen_addresses = '*' 
```
I fil "pg_hba.conf"  findes linjen med 

```
#TYPE  DATABASE        USER            ADDRESS                 METHOD`
```

Umiddelbart under denne *tilføjes*: 

```
local   all             all                                     scram-sha-256
host    all             all             127.0.0.1/32            scram-sha-256
host    all             all             ::1/128                 scram-sha-256
```

Derefter genstartes PostgreSQL (Kan gøres ved at genstarte Widows Server) 

### Opsætning af øvrige parametre til PostgreSQL

Som standard vil eg PostgreSQL installation være sat meget "konservativt" op. Dvs. at Postgres efter installation kan fungere på selv meget små maskiner. 
For at få Postgres til at arbejde optimalt bør man derfor ændre på en række opsætningsparametre
Den bedste metode er iterativ: Ændre et sæt paramre og undersøge om det giver den ønskede effekt. Og derefter tage næste sæt parametre.
Det er en lang og tidskrævende process, som kræver grundig teknisk indsigt i PostgreSQL. 
Se "Tuning Your PostgreSQL Server" (https://wiki.postgresql.org/wiki/Tuning_Your_PostgreSQL_Server)"

Der er en alternativ metode. På følgende hjemmeside "PGTune" (https://pgtune.leopard.in.ua/#/) kan man vælge/indtaste sine Postgres og operativsystem parametre og få genereret et sæt ændringskommandoer.
Disse kommandoer kan herefter eksekveres i Postgres Database serveren vha. PGAdmin værktøjet

Nedenstående ændringskommandoer svarer til en opsætning af Postgres på en server med 2 CPU, 16 GB Ram og SAN Harddiske samt opsætning til "Data warehouse" med 50 samtidige forbindelser

```
# DB Version: 13
# OS Type: windows
# DB Type: dw
# Total Memory (RAM): 16 GB
# CPUs num: 2
# Connections num: 50
# Data Storage: san

ALTER SYSTEM SET
 max_connections = '50';
ALTER SYSTEM SET
 shared_buffers = '4GB';
ALTER SYSTEM SET
 effective_cache_size = '12GB';
ALTER SYSTEM SET
 maintenance_work_mem = '2GB';
ALTER SYSTEM SET
 checkpoint_completion_target = '0.9';
ALTER SYSTEM SET
 wal_buffers = '16MB';
ALTER SYSTEM SET
 default_statistics_target = '500';
ALTER SYSTEM SET
 random_page_cost = '1.1';
ALTER SYSTEM SET
 work_mem = '41943kB';
ALTER SYSTEM SET
 min_wal_size = '4GB';
ALTER SYSTEM SET
 max_wal_size = '16GB';
ALTER SYSTEM SET
 max_worker_processes = '2';
ALTER SYSTEM SET
 max_parallel_workers_per_gather = '1';
ALTER SYSTEM SET
 max_parallel_workers = '2';
ALTER SYSTEM SET
 max_parallel_maintenance_workers = '1';
 
```
