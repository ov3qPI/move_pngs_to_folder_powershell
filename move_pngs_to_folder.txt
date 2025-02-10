# Initialize counters
$count = 0
$total = 0

# Get all .png files in the D:\ drive, excluding the target directory (D:\Pictures\png)
$files = Get-ChildItem -Path D:\ -Recurse -File -Include *.png | Where-Object { $_.DirectoryName -ne "D:\Pictures\png" }

# Total number of files
$total = $files.Count

# Process the files
$files | ForEach-Object {
    $file = $_
    $destinationPath = "D:\Pictures\png\$($file.Name)"

    # Check if the file already exists at the destination
    if (Test-Path -Path $destinationPath) {
        # Option 1: Rename the file (optional)
        $newName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name) + "_$($file.BaseName)" + $file.Extension
        $destinationPath = "D:\Pictures\png\$newName"
    }

    # Move the file to the target directory
    try {
        Move-Item -Path $file.FullName -Destination $destinationPath
        $count++
        Write-Host "Moved $count out of $total files."
    } catch {
        Write-Host "Error moving $($file.FullName): $_"
    }
}

Write-Host "Completed moving $count out of $total files."
