function Read-EncryptedPassword {
    param (
        # Customer name (form subfolder)
        [Parameter(Mandatory)]
        [string]$CustomerName,

        # Name of the .txt containing the password
        [Parameter(Mandatory)]
        [string]$EntryName,

        # Path to where the passwords are stored
        [string]$BasePath = "C:\Lösenord"
    )

    # Creates the path to the passwordfile
    $filePath = Join-Path $BasePath "$CustomerName\$EntryName.txt"

    # Check if file exists
    if (-not (Test-Path $filePath)) {
        Write-Warning "Password file not found: $filePath"
        return
    }

    try {
        
        # Collects the encrypted password
        $encrypted = Get-Content $filePath
        
        # Converts the Secure string
        $secure = $encrypted | ConvertTo-SecureString
        
        # Decrypts the securestring to plain text
        $plain = [System.Net.NetworkCredential]::new("", $secure).Password
        
        # Returns the password in plain text
        return $plain
    } catch {
        
        # Handles errors
        Write-Error "Failed to decrypt password. Are you the original user?"
    }
}

