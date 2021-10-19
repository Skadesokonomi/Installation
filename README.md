# Installationsvejledning til QGIS plugin "Skadesøkonomi" 

Forudsætninger for at kunne benytte plugin "Skadesøkonomi" 
<<<<<<< HEAD
1. QGIS 3.20. Alle vesioner ældre end ver 3.20 har mindre problemer med - via Python - at tilknytte alfanumeriske
(ikke-spatielle) tabeller som lag i QGIS
=======
1. QGIS 3.20. Alle vesioner ældre end ver 3.20 har mindre problemer med at benytte alfanumeriske (ikke-spatielle) tabeller som lag i QGIS, når disse tilknyttes vha. Python.
>>>>>>> 1259a323ed70b9d1fc02c7d4fd742ab8ef3886e2
2. Plugin'et kræver at have en nyere version af PostgreSQL database med extension PostGIS installeret (version >= 10.0)

## Installation af PostgreSQL database system samt PostGIS extension

Hvis man allerede har en Postgres installation med PostGIS extension, kan man springe dette afnit over og gå direkte til afsnit *Opsætning af database på PostgreSQL server til brug for plugin "Skadesøkonomi"*

Installationsvejledning...

## Anskaffelse af installationsfiler til plugin.

- I en web-browser navigerer man til http adresse: https://github.com/Skadesokonomi/Installation
- I skærmbilledet trykker man på den grønne knap, hvorefter der vises en undermenu.
- I undermenuen trykkes på valg "Download ZIP", som igansætter en download af fil "Installation - main.zip"
- Zip-filen udfoldes på et vilkårligt sted i brugerens filsystem 

## Opsætning af database på PostgreSQL server til brug for plugin "Skadesøkonomi"

Vejledningen beskriver, hvorledes man opretter en ny datbase til brug for plugin - inklusive opsætning og navngivning af
database, diverse schemaer samt placering og navngivning af specifikke opslagstabeller til styring af plugin. 

Opsætningen i parametertabellen er tilpasset de medfølgende eksempeldata fra Aabenraa.
 
Dette er ikke absolut nødvendigt at installere eksempeldata og/eller følge denne vejledning mht. til placering og navngivning, 
men det anbefales at den initielle opsætning inkluderer installationen af eksempeldata og at man ikke umiddelbart ændrer opsætningsparametre.

Dette giver brugeren mulighed for at teste systemet med kendte data før import af egne data samt tilpasning af opsætning til disse.

### Oprettelse af schemaer samt administrationstabeller

1. Start PgAdmin4 eller tilsvarende administrationsværktøj. Benyt en database bruger, som har privilegier til oprettelse af scmaer og tabeller i database systemet

2. Opret en ny tom database. Dette skridt er ikke altid nødvendigt; man kan benytte en eksisterende database - blot at man sikrer sig, at denne database ikke allerede 
indeholder schemaerne "fdc_admin", "fdc_data" og "fdc_results". **Hvis databasen gør dette, vil de eksisterende schemaer med indhold blive slettet**  

3. I den nye database åbnes et query vindue, og man indlæser indholdet fra fil: *fdc_script_new_database.sql* fra zip-filen hentet fra GitHub.

4. Kør kommandoerne i scriptet. Scriptet vil gøre følgende:
    - Oprette 3 schemaer "fdc_admin", "fdc_data" og "fdc_results" (og evt slette eksisterende schemaer og indhold med samme navn)
    - Oprette 4 tabeller i schema: "fdc_admin" og indsætte data i disse tabeller: "bbr_anvendelse", "kvm_pris", "parametre", "skadesfunktioner"

5. I schema "fdc_data" kan indlægge eksempel data fra Aabenraa: 
Vælg schema "fdc_data" som det aktive schema og foretag en restore af backup datasæt "fdc_data.backup" inkluderet i zip filen fra GitHub. 
Denne restore vil oprette en række datatabeller i schemaet, så data i parameter tabellen stemmer overens med tabel navne og indhold i schema "fdc_data". 
Efter installationen af plugin "Skadesokonomi" kan man afprøve plugin med det samme, fordi databasen er sat op med data. 






This is the first line. (2 blanks+nl)  
And this is the second line. 

I just love **bold text**.

Italicized text is the *cat's meow*.

This text is ***really important***.

> Dorothy followed her through many of the beautiful rooms in her castle.

> Dorothy followed her through many of the beautiful rooms in her castle.
>> Dorothy followed her through many of the beautiful rooms in her castle.


1. First item
2. Second item
3. Third item
    1. Indented item
    2. Indented item
4. Fourth item 

- First item
- Second item
- Third item
    - Indented item
    - Indented item
- Fourth item 


blah blah

- This is the first list item.
- Here's the second list item.  

        I need to add another paragraph below the second list item.
- And here's the third list item.

```json
{
  "firstName": "John",
  "lastName": "Smith",
  "age": 25
}
```

My favorite search engine is [Duck Duck Go](https://duckduckgo.com).

<https://www.markdownguide.org>  
<fake@example.com>

![The San Juan Mountains are beautiful!](/assets/images/san-juan-mountains.jpg "San Juan Mountains")

\* Without the backslash, this would be a bullet in an unordered list.



Installations repository for projekt Skadesøkonomi



