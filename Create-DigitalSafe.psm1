# Function to create the Digital Safe folder structure

function Create-DigitalSafe {
    param (
        
        # Name of the main folder (default is Digital Safe)
        [string]$FolderName = "Digital Safe"
    )

    # Check for admin privileges
    if (-not ([Security.Principal.WindowsPrincipal] `
        [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
        [Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "You must run this script as Administrator to create folders on C:\" -ForegroundColor Yellow
        return
    }

    # Creates the path to main folder
    $basePath = Join-Path -Path "C:\" -ChildPath $FolderName

    # Create Digital safe main folder if it doesn't exist
    if (-not (Test-Path -Path $basePath)) {
        try {
            New-Item -Path $basePath -ItemType Directory -Force | Out-Null
            Write-Host "Folder '$FolderName' created at C:\" -ForegroundColor Green
        } catch {
            Write-Host "Failed to create the folder: $_" -ForegroundColor Red
            return
        }
    } else {
        Write-Host "Folder '$FolderName' already exists at C:\" -ForegroundColor Cyan
    }

    # Hides the folder with hidden attribute
    try {
        (Get-Item -Path $basePath).Attributes += 'Hidden'
        Write-Host "The folder is now hidden." -ForegroundColor DarkGray
    } catch {
        Write-Host "Failed to hide the folder: $_" -ForegroundColor Red
    }

    # Prompt for subfolders
    while ($true) {
        $subfolder = Read-Host "Enter a name for a subfolder (or press Enter to finish)"
        
        # Ends the loop if enter is pressed without any input
        if ([string]::IsNullOrWhiteSpace($subfolder)) {
            break
        }

        # Creates path to subfolder
        $subPath = Join-Path -Path $basePath -ChildPath $subfolder

        # Creates subfolder if it doesn't exist
        if (-not (Test-Path -Path $subPath)) {
            try {
                New-Item -Path $subPath -ItemType Directory | Out-Null
                Write-Host "Subfolder '$subfolder' created." -ForegroundColor Green
            } catch {
                Write-Host "Failed to create subfolder '$subfolder': $_" -ForegroundColor Red
            }
        } else {
            Write-Host "Subfolder '$subfolder' already exists." -ForegroundColor Cyan
        }
    }
# Tell the user that the Digital Safe is set up
    Write-Host "Digital safe setup complete." -ForegroundColor Green
}

