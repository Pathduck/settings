<#
.SYNOPSIS
    Lists executable files and drivers in a folder with metadata such as Company Name and Description.
.DESCRIPTION
    Scans a directory for specified executable file types (.dll, .exe, .sys, etc.), retrieves 
    their version information, and outputs the results using strict UTF-8 encoding (WITHOUT BOM).
.PARAMETER Path
    The target directory to scan. Defaults to the current working directory ($PWD).
.PARAMETER SortBy
    The column to sort results by. Valid choices: Path, FileName, Modified, CompanyName, Description. Default is FileName.
.PARAMETER Descending
    Sorts the output in descending order when specified.
.PARAMETER Recurse
    Includes files in all subdirectories if specified.
.PARAMETER OutFile
    Optional file path to save the formatted table output directly (UTF-8 without BOM). 
.PARAMETER OutCSV
    Optional file path to export the results directly to a CSV file (UTF-8 without BOM).
.PARAMETER Extensions
    File extensions to search for. Accepts array or comma-separated strings (e.g. "dll, exe" or "*.sys").
.EXAMPLE
    .\Get-FileInfo.ps1 -OutFile "output.txt"
    Scans current directory and saves the formatted table directly to output.txt in UTF-8 without BOM.
.EXAMPLE
    .\Get-FileInfo.ps1 "C:\Windows\System32" CompanyName -Recurse -OutCSV "C:\scan_results.csv"
    Recursively scans System32, sorts by CompanyName, and exports to a CSV file without BOM.
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$Path = $PWD,

    [Parameter(Position = 1)]
    [ValidateSet("Path", "FileName", "Modified", "CompanyName", "Description")]
    [string]$SortBy = "FileName",

    [switch]$Descending,

    [switch]$Recurse,

    [string]$OutFile,

    [string]$OutCSV,

    [string[]]$Extensions = @("*.dll", "*.exe", "*.sys", "*.ocx", "*.cpl", "*.drv", "*.ax", "*.mui", "*.scr")
)

# UTF-8 encoder explicitly configured to NOT emit BOM ($false)
$Utf8NoBom = New-Object System.Text.UTF8Encoding $false
$OutputEncoding = $Utf8NoBom
[Console]::OutputEncoding = $Utf8NoBom

# Append wildcard if non-recursive so -Include works properly
$SearchPath = if (-not $Recurse -and -not $Path.EndsWith('*')) { Join-Path $Path '*' } else { $Path }

# Clean, split, and normalize extensions
$FormattedExtensions = $Extensions | ForEach-Object { $_ -split ',' } | ForEach-Object {
    $ext = $_.Trim()
    if ($ext -and $ext -notlike "*.*") { "*.$ext" } else { $ext }
} | Where-Object { $_ }

$Results = Get-ChildItem -Path $SearchPath -Include $FormattedExtensions -File -Recurse:$Recurse -ErrorAction SilentlyContinue | ForEach-Object {
    [PSCustomObject]@{
        Path        = $_.DirectoryName
        FileName    = $_.Name
        Modified    = $_.LastWriteTime
        CompanyName = $_.VersionInfo.CompanyName
        Description = $_.VersionInfo.FileDescription
    }
} | Sort-Object -Property $SortBy -Descending:$Descending

# Export to CSV (UTF-8 No BOM)
if ($OutCSV) {
    $ResolvedCsvPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutCSV)
    $CsvLines = $Results | ConvertTo-Csv -NoTypeInformation
    [System.IO.File]::WriteAllLines($ResolvedCsvPath, $CsvLines, $Utf8NoBom)
    Write-Host "Exported $($Results.Count) results to CSV: '$ResolvedCsvPath'" -ForegroundColor Green
}

# Output Table (Console or Text File UTF-8 No BOM)
if ($OutFile) {
    $ResolvedOutFile = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutFile)
    $TableText = ($Results | Format-Table -AutoSize | Out-String)
    [System.IO.File]::WriteAllText($ResolvedOutFile, $TableText, $Utf8NoBom)
    Write-Host "Exported $($Results.Count) results to file: '$ResolvedOutFile'" -ForegroundColor Green
} elseif (-not $OutCSV) {
    $Results | Format-Table -AutoSize
}