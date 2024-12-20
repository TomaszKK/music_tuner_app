# Path to your pubspec.yaml file
$pubspecPath = "pubspec.yaml"
$pubspecContent = Get-Content $pubspecPath -Raw

# Regex to extract the current version
$versionRegex = 'version: (\d+\.\d+\.\d+)'

if ($pubspecContent -match $versionRegex) {
    # Extract the current version (major.minor.patch)
    $version = $matches[1]

    # Split the version into components
    $versionComponents = $version -split '\.'

    # Increment the patch version (the last number)
    $newPatchVersion = [int]$versionComponents[2] + 1
    $versionComponents[2] = $newPatchVersion.ToString()

    # Reassemble the version into major.minor.patch
    $newVersion = "$($versionComponents[0]).$($versionComponents[1]).$($versionComponents[2])"

    # Construct the new version line
    $newVersionLine = "version: $newVersion"

    # Replace the old version line with the new one
    $updatedContent = $pubspecContent -replace $versionRegex, $newVersionLine

    # Save the updated content back to pubspec.yaml
    Set-Content $pubspecPath -Value $updatedContent

    # Print the new version for verification
    Write-Host "Updated version: $newVersion"

#     # Run Flutter build
#     flutter build apk --release
} else {
    Write-Host "No version line found in pubspec.yaml"
}
