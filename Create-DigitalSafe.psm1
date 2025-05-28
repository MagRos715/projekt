function Create-DigitalSafe {
    param (
        [string]$FolderName = "Digital Safe"
    )

    # Check for admin privileges
    if (-not ([Security.Principal.WindowsPrincipal] `
        [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
        [Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "You must run this script as Administrator to create folders on C:\" -ForegroundColor Yellow
        return
    }

    $basePath = Join-Path -Path "C:\" -ChildPath $FolderName

    # Create base folder
    if (-not (Test-Path -Path $basePath)) {
        try {
            New-Item -Path $basePath -ItemType Directory -Force | Out-Null
            Write-Host "✔ Folder '$FolderName' created at C:\" -ForegroundColor Green
        } catch {
            Write-Host "✖ Failed to create the folder: $_" -ForegroundColor Red
            return
        }
    } else {
        Write-Host "ℹ Folder '$FolderName' already exists at C:\" -ForegroundColor Cyan
    }

    # Set hidden attribute
    try {
        (Get-Item -Path $basePath).Attributes += 'Hidden'
        Write-Host "✔ The folder is now hidden." -ForegroundColor DarkGray
    } catch {
        Write-Host "✖ Failed to hide the folder: $_" -ForegroundColor Red
    }

    # Prompt for subfolders
    while ($true) {
        $subfolder = Read-Host "📁 Enter a name for a subfolder (or press Enter to finish)"
        if ([string]::IsNullOrWhiteSpace($subfolder)) {
            break
        }

        $subPath = Join-Path -Path $basePath -ChildPath $subfolder

        if (-not (Test-Path -Path $subPath)) {
            try {
                New-Item -Path $subPath -ItemType Directory | Out-Null
                Write-Host "✔ Subfolder '$subfolder' created." -ForegroundColor Green
            } catch {
                Write-Host "✖ Failed to create subfolder '$subfolder': $_" -ForegroundColor Red
            }
        } else {
            Write-Host "ℹ Subfolder '$subfolder' already exists." -ForegroundColor Cyan
        }
    }

    Write-Host "`n✅ Digital safe setup complete." -ForegroundColor Green
}
