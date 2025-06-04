# Function to read an encrypted password from a file

function Read-EncryptedPassword {
    param (
        # Customer name (from subfolder)
        [Parameter(Mandatory)]
        [string]$CustomerName,

        # Name of the .txt containing the password
        [Parameter(Mandatory)]
        [string]$NamePasswordFile,

        # Path to where the passwords are stored
        [string]$BasePath = "C:\Digital Safe"
    )

    # Creates the path to the password file
    $filePath = Join-Path $BasePath "$CustomerName\$NamePasswordFile.txt"

    # Check if file exists
    if (-not (Test-Path $filePath)) {
        Write-Warning "Password file not found: $filePath" -ForegroundColor Red
        return
    }

    try {
        # Collects the encrypted password
        $encrypted = Get-Content $filePath

        # Converts the SecureString
        $secure = $encrypted | ConvertTo-SecureString -ErrorAction Stop

        # Decrypts the securestring to plain text
        $plain = [System.Net.NetworkCredential]::new("", $secure).Password

        # Show password
        Write-Host "`nDecrypted password for '$NamePasswordFile':" -ForegroundColor Yellow
        Write-Host "`n$plain`n" -ForegroundColor White

        # Wait 10 seconds and clear terminal
        Start-Sleep -Seconds 10
        Clear-Host
        Write-Host "Password visibility time has expired." -ForegroundColor DarkGray

        # Ask if password should be copied to clipboard
        $confirm = Read-Host "Do you want to copy the password to the clipboard? (Y/N)"
        if ($confirm -match '^[Yy]$') {
            $plain | Set-Clipboard
            Write-Host "Password copied to clipboard." -ForegroundColor Green
        }
        else {
            Write-Host "Password not copied." -ForegroundColor Cyan
        }

    } catch {
        # Handles errors
        Write-Error "Failed to decrypt password. Are you the original user?"
    }
}
