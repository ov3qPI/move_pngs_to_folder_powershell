# Set the directory path
$directoryPath = "D:\Pictures"

# Function to generate a random alphanumeric string of length 6
function Get-RandomString {
    $length = 6
    $characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    $randomString = -join ((1..$length) | ForEach-Object { $characters[(Get-Random -Minimum 0 -Maximum $characters.Length)] })
    return $randomString
}

# Array to store already renamed files
$renamedFiles = @()

# Initialize counters
$count = 0
$total = 0

# Get all .png files in the directory and its subdirectories
$files = Get-ChildItem -Path $directoryPath -Recurse -Filter "*.png"

# Total number of files
$total = $files.Count

# Process the files
$files | ForEach-Object {
    $oldFile = $_
    
    # Check if the file is already renamed (check if it's in the renamed files array)
    if ($renamedFiles -contains $oldFile.FullName) {
        Write-Host "`rSkipping '$($oldFile.FullName)' (already renamed) ($count out of $total)" -NoNewline
    } else {
        # Generate a new random name
        $newName = (Get-RandomString) + ".png"
        $newFilePath = Join-Path -Path $oldFile.DirectoryName -ChildPath $newName
        
        # Check if the new file already exists to avoid overwriting
        if (-not (Test-Path -Path $newFilePath)) {
            Rename-Item -Path $oldFile.FullName -NewName $newFilePath
            $renamedFiles += $oldFile.FullName  # Add renamed file to the list
            $count++
            Write-Host "`rRenamed '$($oldFile.FullName)' to '$newFilePath' ($count out of $total)" -NoNewline
        } else {
            Write-Host "`rSkipping '$($oldFile.FullName)' (filename already exists) ($count out of $total)" -NoNewline
        }
    }
}

Write-Host "`rCompleted renaming $count out of $total files."
