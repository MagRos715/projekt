# Digital Safe – PowerShell

Ett projekt utvecklat av Henrik Karlsson, Magnus Rosenlund och Jesper Olsén inom utbildningen YH-Cloud24.

## Syfte

Digital Password Safe är ett PowerShell-baserat verktyg som hjälper enskilda användare att hantera starka lösenord på ett säkert och strukturerat sätt. All data genereras och lagras lokalt – utan externa tjänster eller internetanslutning – och skyddas med stark kryptering.

## Funktioner

- Genererar starka, slumpmässiga lösenord.
- Krypterar lösenord med DPAPI.
- Sparar lösenord i en dold mappstruktur.
- Krypterar filen med Windows Encrypting File System (EFS).
- Visar dekrypterat lösenord i 10 sekunder.
- Ger möjlighet att kopiera lösenord till urklipp.
- Rensar terminalen efter visning.

## Struktur

Scriptet är uppdelat i tre moduler:

### 1. Create-DigitalSafe
Skapar en huvudmapp och valfri undermapp för lösenord.

### 2. Generate-RandomPassword
Genererar ett slumpmässigt lösenord, krypterar det och sparar det i en textfil. Textfilen krypteras sedan med EFS.

### 3. Read-EncryptedPassword
Dekrypterar lösenordsfilen, visar lösenordet temporärt och ger möjlighet att kopiera det till urklipp.

## Användning

1. Öppna PowerShell som administratör.
2. Navigera till katalogen där scriptet är sparat:
   ```powershell
   cd "C:\Sökväg\Till\Script"
   ```
3. Kör huvudfilen:
   ```powershell
   .\main.ps1
   ```
4. Kör modulerna i följande ordning:
   - `Create-DigitalSafe`
   - `Generate-RandomPassword`
   - `Read-EncryptedPassword`

## Designöverväganden

Projektet bygger på idén att starka lösenord måste vara både unika och svåra att komma ihåg. Därför automatiseras både skapande och lagring i en lokal, krypterad miljö.

För att minimera sårbarhet:
- Allt lagras lokalt.
- Inget skickas via nätverk.
- Data krypteras både i innehåll (med DPAPI) och på filnivå (med EFS).
- Åtkomst är knuten till användarens certifikat och SID.

## Reflektion

Vi har valt att använda Windows inbyggda krypteringsfunktioner för att säkerställa kompatibilitet och undvika externa beroenden. Projektet har krävt omfattande diskussioner om säkerhet, användbarhet och praktisk implementation. Flera funktioner har medvetet utelämnats för att behålla tydlighet och användarvänlighet.

Projektets främsta styrka är att det ger användaren kontroll över sin lösenordshantering utan att kräva extern mjukvara eller internetuppkoppling. All funktionalitet är tillgänglig i ett enkelt, skriptbaserat gränssnitt.

Sammarbetet har varit bra p.g.a att arbetet har bedrivits mestadels tillsammans på samma plats. Remote location har undvikts för att minska problem med push to git. Skapandet av koden har bedrivits i sammförstånd med alla medlemmar för ökad förståelse för koden. Arbete som genomförts remote har sparats och testat lokalt för att sedan presentera för resten av medlemmarna innan push till repo.

## Vidareutveckling

- GUI-gränssnitt för förbättrad användarupplevelse.
- Alternativa krypteringsmetoder för digital backup.
- Automatisk tömning av urklipp.
- Rättighetsstyrning för mappar och filer.
- Skapa en true randomizer baserat på t.ex användarens rörelser med mus eller touchpad över en yta
- Rensa urklipp efter t.ex en minut

## Rekommendationer

För ytterligare skydd rekommenderas användning av BitLocker samt Windows Hello för autentisering. Säker användning förutsätter ett grundläggande säkerhetsmedvetande hos slutanvändaren.
