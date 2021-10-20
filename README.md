# Installationsvejledning til QGIS plugin "Skadesøkonomi"

Forudsætninger for at kunne benytte plugin "Skadesøkonomi": 
1. QGIS 3.20. Alle versioner ældre end ver 3.20 har mindre problemer med - via Python - at tilknytte alfanumeriske
(ikke-spatielle) tabeller som lag i QGIS.
2. Plugin'et kræver at have en nyere version af PostgreSQL database med extension PostGIS 
installeret (version >= 10.0) til rådighed.

## Installation af PostgreSQL database system samt PostGIS extension

Hvis man allerede har en Postgres installation med PostGIS extension, kan man springe dette afnit over og gå direkte til afsnit *"Installation af PostGIS extension"* eller *Opsætning af database på PostgreSQL server til brug for plugin "Skadesøkonomi"*

Brug hjemmeside: https://www.postgresqltutorial.com/install-postgresql/

Der er 2 forskelle fra ovenstående installationsvejledning:

1.0 Brug ver. 13.4 af PostgreSQL.

2.0 Sæt et "hak" ved Stack Builder i Skærmbillede "Select components". Dette starter programmet "StackBuilder" som giver dig mulighed for at installere PostGIS


## Installation af PostGIS extension

https://postgis.net/workshops/postgis-intro/installation.html

1.0 Sæt "hak" ved ver 3.1 af PostGis.


## Anskaffelse af installationsfiler til plugin.

- I en web-browser navigerer man til http adresse: https://github.com/Skadesokonomi/Installation
- I skærmbilledet trykker man på den grønne knap "Code", hvorefter der vises en undermenu.
- I undermenuen trykkes på valg "Download ZIP", som igansætter en download af fil "Installation - main.zip"
- Zip-filen udfoldes på et vilkårligt sted i brugerens filsystem.

## Opsætning af database på PostgreSQL server til brug for plugin "Skadesøkonomi"

Dette afsnit beskriver, hvorledes man opretter en ny database til brug for plugin - inklusive opsætning og navngivning af
database, diverse schemaer samt placering og navngivning af specifikke opslagstabeller til styring af plugin. 

Data i parametertabellen er tilpasset de medfølgende eksempeldata.
 
Dette er ikke absolut nødvendigt at installere eksempeldata og/eller følge denne vejledning mht. til placering og navngivning, 
men det anbefales at den initielle opsætning inkluderer installationen af eksempeldata og at man ikke umiddelbart ændrer opsætningsparametre.

Dette giver brugeren mulighed for at teste systemet med kendte data før import af egne data samt tilpasning af opsætning af systemet til disse.

### Oprettelse af schemaer samt administrationstabeller

1. Start PgAdmin4 eller tilsvarende administrationsværktøj. Benyt en database bruger, som har privilegier til 
oprettelse af databaser, schemaer og tabeller i database systemet.

2. Opret evt. en ny tom database. Dette skridt er ikke altid nødvendigt. Man kan benytte en eksisterende database -
blot at man sikrer sig, at denne database ikke allerede 
indeholder schemaerne "fdc_admin", "fdc_data" og "fdc_results". 
**Hvis databasen gør dette, vil de eksisterende schemaer med indhold blive slettet**  

3. I den nye database åbnes et vindue til indtastning af SQL kommandoer (query vindue), og man indlæser/copy-paster indholdet
fra fil: *fdc_script_new_database.sql* fra zip-filen hentet fra GitHub.

4. Udfør kommandoerne i scriptet. Scriptet vil gøre følgende:

    - Oprette 3 schemaer "fdc_admin", "fdc_data" og "fdc_results" (og evt slette eksisterende schemaer og indhold med samme navn)

    - Oprette 4 tabeller i schema: "fdc_admin" og indsætte data i disse tabeller: "bbr_anvendelse", "kvm_pris", "parametre", "skadesfunktioner"

5. I schema "fdc_data" *kan* man indlægge eksempeldata. Dette anbefales, fordi 
denne restore vil oprette en række datatabeller i schemaet, så data i parameter tabellen stemmer overens med tabel navne og indhold i schema "fdc_data". 
Efter installationen af plugin "Skadesokonomi" kan man afprøve plugin med det samme, fordi databasen vil være sat op med eksempel data samt en korret opsætning for disse eksempeldata.
 
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

2. I "Datakilde håndtering" / "Data source Manager" (Ctrl-L), faneblad "PostgreSQL" skal der oprettes en forbindelse til databasen med data til "Skadesøkonomi". Husk navnet på forbindelsen. 

3. Start "Skadesøkonomi" plugin vha. menupunkt: "Plugins" --> "Skadeøkonomi" -->  "Vis skærmbillede"

4. Ved første opstart vises der altid en fejlmeddelelse: "**EcoModel : Database forbindelse eller parametertabel ikke værdisat**". 
Dette skyldes, at plugin ikke er sat op til at benytte den korrekte database forbindelse. Man retter dette med følgende:

    1. Tryk på knap "Administration" (nederst til højre i plugin skærmbillede).  Der vises tre ekstra faneblade "Generelt", "Forespørgsler" og  "Data".

	2. Aktivér faneblad "Generelt"

	3. I afsnit "Databasekilde", drop-down valgliste for felt "Database" vælges databaseforbindelsen for "Skadeøkonomi"  data

	4. I tekstfelt "Parameter tabel" skrives navnet for tabellen med parameter data. Hvis man har benyttet installations script og derved fulgt standard installationen
	for databasen er det ikke nødvendigt at foretage ændringer i dette felt. 

	5. Tryk på knap "Genindlæs parametre" (nederst i midten i plugin skærmbillede)
	
        De forskellige faneblade fyldes nu med oplysninger og data. Systemet husker dine valg, så der ikke forekommer fejl ved næste opstart.

    6. Tryk på knap "Administration" igen. De tre ekstra faneblade "Generelt", "Forespørgsler" og  "Data" forsvinder.
	
	