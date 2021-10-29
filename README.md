# Installationsvejledning til QGIS plugin "Skadesøkonomi"

Der findes følgende forudsætninger for at kunne benytte plugin "Skadesøkonomi":
 
- QGIS 3.20. QGIS versioner ældre end ver 3.20 har mindre problemer med - via Python - at tilknytte alfanumeriske
(ikke-spatielle) tabeller som lag i QGIS.

- Plugin'et kræver at have en nyere version af PostgreSQL database med extension PostGIS 
installeret (version >= 10.0) til rådighed.

## Installation af PostgreSQL database systemet samt PostGIS extensionen

Hvis man allerede har en Postgres installation, kan man springe dette afnit over og gå direkte til afsnit *"Installation af PostGIS extension"* eller *Opsætning af database på PostgreSQL server til brug for plugin "Skadesøkonomi"*

Brug hjemmeside: https://www.postgresqltutorial.com/install-postgresql/

Der er nogle forskelle fra ovenstående installationsvejledning:

- Brug ver. 13.4 af PostgreSQL.

- Husk port nummer (normalt 5432). Det skal du bruge, når du opsætter forbindelsen mellem QGIS og PostgreSQL.

- Husk det password, du indtaster. Dette skal, sammen med username "postgres", bruges til at forbinde QGIS og PGadmin til PostgreSQL. 

- Sæt et "hak" ved Stack Builder i Skærmbillede "Select components". Dette starter programmet "StackBuilder" som giver dig mulighed for at installere PostGIS


## Installation af PostGIS extension

https://postgis.net/workshops/postgis-intro/installation.html

- Vælg PostgreSQL server instans - typisk: "PostgreSQL 13 (x64) on port 5432" - og tryk på knap "Next"

- I det nye skærmbillede: Udfold gren "Spatial extensions" og sæt "hak" ved ver 3.1 af PostGis.

- Acceptér alle standard valg og div. spørgsmål om miljøvariable (Environment variables)


## Anskaffelse af installationsfiler til plugin.

- I en web-browser navigerer man til http adresse: https://github.com/Skadesokonomi/Installation

- I skærmbilledet trykker man på den grønne knap "Code", hvorefter der vises en undermenu.

- I undermenuen trykkes på valg "Download ZIP", som igansætter en download af fil "Installation - main.zip"

- Efter download er færdig, udfoldes zip-filen på et vilkårligt sted i brugerens filsystem.

## Opsætning af database på PostgreSQL server til brug for plugin "Skadesøkonomi"

Dette afsnit beskriver, hvorledes man opretter en ny database til brug for plugin - inklusive opsætning og navngivning af
database, diverse schemaer samt placering og navngivning af specifikke opslagstabeller til styring af plugin. 

Data i parametertabellen er tilpasset de medfølgende eksempeldata.
 
Dette er ikke *absolut* nødvendigt at installere eksempeldata og/eller følge denne vejledning mht. til placering og navngivning, 
men det anbefales at den initielle opsætning inkluderer installationen af eksempeldata og at man ikke umiddelbart ændrer opsætningsparametre.

Dette giver brugeren mulighed for at teste systemet med kendte data før import af egne data samt tilpasning af opsætning af systemet til disse.

### Oprettelse af schemaer samt administrationstabeller

- Start PgAdmin4 eller tilsvarende administrationsværktøj. Benyt en database bruger-konto, som har privilegier til 
oprettelse af databaser, schemaer og tabeller i database systemet.

- Opret evt. en ny tom database. Dette skridt er ikke altid nødvendigt. Man kan benytte en eksisterende database -
blot at man sikrer sig, at denne database ikke allerede indeholder schemaerne "fdc_admin", "fdc_data" og "fdc_results". 
**Hvis databasen gør dette, vil de eksisterende schemaer med indhold blive slettet**  

- I den nye database åbnes et vindue til indtastning af SQL kommandoer (query vindue), og man indlæser/copy-paster indholdet
fra fil: *fdc_script_new_database.sql* fra zip-filen hentet fra GitHub.

- Udfør kommandoerne i scriptet. Scriptet vil gøre følgende:

    - Oprette 3 schemaer "fdc_admin", "fdc_data" og "fdc_results" (og evt slette eksisterende schemaer og indhold med samme navn)

    - Oprette 4 tabeller i schema: "fdc_admin" og indsætte data i disse tabeller: "bbr_anvendelse", "kvm_pris", "parametre", "skadesfunktioner"

- I schema "fdc_data" kan man indlægge eksempeldata fra backup fil: "fdc_data.backup" i den den dowbloadede zip-fil. Dette anbefales, fordi denne restore vil oprette en række datatabeller i schemaet, så oplysninger (data) i parameter tabellen stemmer overens med tabel navne og indhold i schema "fdc_data". 
Efter installationen af plugin "Skadesokonomi" kan man afprøve plugin'et med det samme, fordi databasen vil være sat op med eksempel data samt en korret opsætning for disse eksempeldata.
 
    - Vælg schema "fdc_data" som det aktive schema og foretag en restore af backup datasæt "fdc_data.backup" inkluderet i zip filen fra GitHub. 


## Installation af plugin i QGIS

1. Start QGIS

2. Vælg menupunkt "Plugins" --> "Administrér og Installér plugins..." --> (Lodret) Faneblad "Installér fra ZIP"

3. I det viste brugerskærmbillede "Plugins | Installér fra ZIP", felt: "ZIP fil:" Indtastes det fulde sti- og filnavn for zip-filen "ecomodel.zip", som er inkluderet i den hentede zip "installation - main.zip" fra GitHub.
Man kan også benytte knappen umiddelbart til højre for indtastningsfeltet for at få vist et skærmbillede til at vælge zip filen.

4. Man afslutter installationen ved at trykke på knap "Installér Plugin" 

## Første gangs opsætning af plugin i QGIS

Før brug skal plugin forbindes til Postgres databasen som indeholder schemaer og tabeller til "Skadesøkonomi".
Dette gøres med følgende:

1. Start QGIS 

2. I "Datakilde håndtering" / "Data source Manager" (**Ctrl-L**), faneblad "PostgreSQL" skal der oprettes en forbindelse til databasen med data til "Skadesøkonomi". Husk navnet på forbindelsen.

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
	
## Simpel backup procedure til at sikkerhedskopiere schemaer med tabeller til en specifik mappe

zip filen fra GitHub indeholder 2 DOS kommmando-procedurer som kan foretage sikkerhedskopiering af de forskellige database schemaer
 
 - "pg_backup_schema.cmd", som er selve backup proceduren. Proceduren benytter sig af backup programmet pg_dump.exe, som følger med alle postgres installationer. Der er en række parametre i denne procedure, som skal tilpasses det specifikke system. Alle parametre er dokumenteret direkte i proceduren, som kan redigeres med en simpel tekst editor, f.kes. NotePad
 
 - "pg_backup_schema_example.cmd", er et eksempel på, hvorledes backup proceduren bliver aktiveret. Denne kommandoprocedure er også selv-dokumenterende.
 
 Opsætning foregår som følger: 
 
 - De 2 procedurer kopieres til et vilkårlig placering på pc eller netværket. De skal placeres i samme mappe for at fungere korrekt. 
 
 - Computeren, som skal udføre backup, skal have adgang til mapper til opbevaring af backup data, mappen med de to procedurter samt mappen med pg_dump.exe
 
 - pg_backup_schema.cmd redigeres, så parametrene vedr. hostname, portnummer, databasenavn, database bruger, password samt placering af postgres pg_dump.exe er sat korrekt op.
 
 - pg_backup_schema_example.cmd redigeres således databasenavn, schemanavne samt mappe for backupfilerne er korrekte. Selve navnet på filen kan også rettes. 
 
Selve proceduren kan udføres manuelt: Via Stifinder dobbeltklikkes på den rettede pg_backup_schema_example.cmd. Herefter foretages backuppen.

Man kan alternativt opsætte udføreslen i Windows opgave styring. Her skal man aktivere "pg_backup_schema_example.cmd" uden andre parametre. 
