# Installationsvejledning til QGIS plugin "Skadesøkonomi" 

Forudsætninger for at kunne benytte plugin "Skadesøkonomi" 
1. QGIS 3.20. Alle vesioner ældre end ver 3.20 har mindre problemer med at benytte alfanumeriske (ikke-spatielle) tabeller som lag i QGIS, når disse tilknyttes vha. Python.
2. Plugin'et kræver at have en nyere version af PostgreSQL database med extension PostGIS installeret (version >= 10.0)

## Installation af PostgreSQL database system samt PostGIS extension

Hvis man allerede har en Postgres installation med PostGIS extension, kan man springe dette afnit over og gå direkte til afsnit *Opsætning af database på PostgreSQL server til brug for plugin "Skadesøkonomi"*

Installationsvejledning...

## Opsætning af database på PostgreSQL server til brug for plugin "Skadesøkonomi"

Vejledningen beskriver hvorledes man opretter en ny datbase til brug for plugin, inklusive opsætning og navngivning af
database, diverse schemaer samt placering og navngivning af specifikke opslagstabeller til styring af plugin. Dette er ikke absolut nødvendigt at følge
denne vejledning mht. til placering og navngivning, men det anbefales at den initielle opsætning følger vejledningen. Dette
vil senere overflødiggøre en række ellers nødvendige rettelser i data i parametertabellen





# Heading level 1

I really like using Markdown.

I think I'll use it to format all of my documents from now on. 

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



