function Read-EncryptedPassword {
    param (
        [Parameter(Mandatory)]
        [string]$CustomerName,

        [Parameter(Mandatory)]
        [string]$EntryName,

        [string]$BasePath = "C:\Lösenord"
    )

    $filePath = Join-Path $BasePath "$CustomerName\$EntryName.txt"

    if (-not (Test-Path $filePath)) {
        Write-Warning "Password file not found: $filePath"
        return
    }

    try {
        $encrypted = Get-Content $filePath
        $secure = $encrypted | ConvertTo-SecureString
        $plain = [System.Net.NetworkCredential]::new("", $secure).Password
        return $plain
    } catch {
        Write-Error "Failed to decrypt password. Are you the original user?"
    }
}
