# Imports module to create Digital-Safe folder structure
Import-Module "$PSScriptRoot\Create-DigitalSafe.psm1"

# Imports module to generate random passwords and saves to .txt
Import-Module "$PSScriptRoot\Generate-RandomPassword.psm1"

# Imports module to read encrypted passwords from .txt
Import-Module "$PSScriptRoot\Read-EncryptedPassword.psm1"