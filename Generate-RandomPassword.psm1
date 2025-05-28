function Generate-RandomPassword {
    param (
        [Parameter(Mandatory)]
        [string]$CustomerName,

        [Parameter(Mandatory)]
        [string]$EntryName,

        [string]$BasePath = "C:\Lösenord"
    )

    $Length = 32

    $upper   = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".ToCharArray()
    $lower   = "abcdefghijklmnopqrstuvwxyz".ToCharArray()
    $digits  = "0123456789".ToCharArray()
    $special = "!@#$%^&*_-+=?".ToCharArray()
    $all     = $upper + $lower + $digits + $special

    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()

    function Get-RandomChar($array) {
        $byte = New-Object 'System.Byte[]' 1
        do {
            $rng.GetBytes($byte)
            $index = $byte[0] % $array.Length
        } while ($index -ge $array.Length)
        return $array[$index]
    }

    $passwordChars = @(
        Get-RandomChar $upper
        Get-RandomChar $lower
        Get-RandomChar $digits
        Get-RandomChar $special
    )

    for ($i = 4; $i -lt $Length; $i++) {
        $passwordChars += Get-RandomChar $all
    }

    $password = ($passwordChars | Sort-Object {Get-Random}) -join ""

    # 🔐 Kryptering
    $secure = ConvertTo-SecureString -String $password -AsPlainText -Force
    $encrypted = $secure | ConvertFrom-SecureString

    # Skapa mapp om den inte finns
    $customerPath = Join-Path $BasePath $CustomerName
    if (-not (Test-Path $customerPath)) {
        New-Item -Path $customerPath -ItemType Directory -Force | Out-Null
        Write-Host "Created customer folder: $customerPath"
    }

    # 💾 ❗ Spara endast den krypterade strängen
    $filePath = Join-Path $customerPath "$EntryName.txt"
    $encrypted | Set-Content -Path $filePath -Encoding UTF8

    Write-Host "Encrypted password saved to: $filePath"
    return
}

