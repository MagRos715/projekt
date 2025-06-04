# Function to Generate random password and create subfolder with .txt if not exist

function Generate-RandomPassword {
    param (
        # Customer name to be used for subfolder
        [Parameter(Mandatory)]
        [string]$CustomerName,

        # Name of password to be used as name of .txt
        [Parameter(Mandatory)]
        [String]$NamePasswordFile,

        # Path where password will be created
        [string]$BasePath = "C:\Digital Safe"
    )

    # Defines the length of the password
    $Length = 32

    # Defines what type of characters that will be used in password
    $upper   = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".ToCharArray()
    $lower   = "abcdefghijklmnopqrstuvwxyz".ToCharArray()
    $digits  = "0123456789".ToCharArray()
    $special = "!@#$%^&*_-+=?".ToCharArray()
    $all     = $upper + $lower + $digits + $special

    # Creates a cryptographic randomizer
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()

    # Function to randomly create character from an array of characters
    function Get-RandomChar($array) {
        $byte = New-Object 'System.Byte[]' 1
        do {
            $rng.GetBytes($byte)
            $index = $byte[0] % $array.Length
        } while ($index -ge $array.Length)
        return $array[$index]
    }

    # Lets the password contain at least one character from each category
    $passwordChars = @(
        Get-RandomChar $upper
        Get-RandomChar $lower
        Get-RandomChar $digits
        Get-RandomChar $special
    )

    # Generates characters to fill the remaining characters in password
    for ($i = 4; $i -lt $Length; $i++) {
        $passwordChars += Get-RandomChar $all
    }

    <# Randomizes the order of the characters and creates the final version
    of the password and converts it to a string#>
    $password = ($passwordChars | Sort-Object {Get-Random}) -join ""

    # Encrypts the password as a secure string
    $secure = ConvertTo-SecureString -String $password -AsPlainText -Force
    
    # Converts the secure string to cypher text
    $encrypted = $secure | ConvertFrom-SecureString

    # Create customerfolder if not exist
    $customerPath = Join-Path $BasePath $CustomerName
    if (-not (Test-Path $customerPath)) {
        New-Item -Path $customerPath -ItemType Directory -Force | Out-Null
        Write-Host "Created customer folder: $customerPath" -ForegroundColor Green
    }

    # Creates the path to the file and saves the encrypted password
    $filePath = Join-Path $customerPath "$NamePasswordFile.txt"
    $encrypted | Set-Content -Path $filePath -Encoding UTF8

    # Creates a confirmation and prompts it to the user
    Write-Host "Encrypted password saved to: $filePath" -ForegroundColor Green

    # File Encryption using EFS

    if (Test-Path $filePath) {
        cipher /E "$filePath" | Out-Null
        Write-Host "File encrypted with EFS: $filePath" -ForegroundColor Green
    } else {
        Write-Warning "File not found for EFS encryption: $filePath" -ForegroundColor Red
    }
}
Return