function Read-EncryptedPassword {
    param (
        # Customer name (form subfolder)
        [Parameter(Mandatory)]
        [string]$CustomerName,

        # Name of the .txt containing the password
        [Parameter(Mandatory)]
        [string]$NamePasswordFile,

        # Path to where the passwords are stored
        [string]$BasePath = "C:\Digital Safe"
    )

    # Creates the path to the passwordfile
    $filePath = Join-Path $BasePath "$CustomerName\$NamePasswordFile.txt"

    # Check if file exists
    if (-not (Test-Path $filePath)) {
        Write-Warning "Password file not found: $filePath"
        return
    }

    try {
        
        # Collects the encrypted password
        $encrypted = Get-Content $filePath
        
        # Converts the Secure string
<<<<<<< HEAD
        $secure = $encrypted | ConvertTo-SecureString -ErrorAction stop
=======
        $secure = $encrypted | ConvertTo-SecureString -ErrorAction Stop
>>>>>>> 71ebfb4a2a0949a88b6fb1f071ae37f4a7c238bc
        
        # Decrypts the securestring to plain text
        $plain = [System.Net.NetworkCredential]::new("", $secure).Password
        
        # Returns the password in plain text
        return $plain
    } catch {
        
        # Handles errors
        Write-Error "Failed to decrypt password. Are you the original user?"
    }
}

