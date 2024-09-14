param(
	[Parameter(Mandatory = $true, Position = 0)]
	[ValidateScript({
			if (Test-Path $_ -PathType Container) {
				return $true
			} else {
				throw "The path '$_' is not a valid directory."
			}
		})]
	[string]$path,

	[Parameter(Mandatory = $false)]
	[switch]$Delete
)

# Define the regex pattern to match the conflict files
$pattern = "\(conflict \d{4}-\d{2}-\d{2}-\d{2}-\d{2}-\d{2}\)"

# Get all files recursively from the specified path and filter those matching the pattern
$files = Get-ChildItem -Path $path -File -Recurse |
Where-Object { $_.Name -match $pattern }

if ($files.Count -eq 0) {
	Write-Host "No files matching the pattern were found in the specified path."
} else {
	if ($Delete) {
		# List the files before deletion
		Write-Host "You are about to delete the following files:" -ForegroundColor Yellow
		foreach ($file in $files) {
			Write-Host $file.FullName
		}
		$confirmation = Read-Host "Type 'Y' to confirm deletion"

		if ($confirmation -eq 'Y') {
			# Delete the matching files
			$files | Remove-Item -Force
			Write-Host "Deleted the following files:"
			foreach ($file in $files) {
				Write-Host $file.FullName
			}
		} else {
			Write-Host "Deletion canceled."
		}
	} else {
		# List the matching files
		Write-Host "Found the following files matching the pattern:"
		foreach ($file in $files) {
			Write-Host $file.FullName
		}
	}
}
