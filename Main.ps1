# Skapar Digital-Safe och undermappar.
Import-Module "$PSScriptRoot\Create-DigitalSafe.psm1"

# Importerar modulen som genererar ett random, krypterat lösenord.
Import-Module "$PSScriptRoot\Generate-RandomPassword.psm1"

# Dekrypterar krypterade lösenord som sparats i textfiler.
Import-Module "$PSScriptRoot\Read-EncryptedPassword.psm1"