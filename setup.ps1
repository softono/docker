param (
    [Parameter(Position=0)]
    [string]$FolderName
)

if (-not $FolderName) {
    Write-Host "Usage: .\setup.ps1 <folder_name>"
    exit 1
}

if (-not (Test-Path -Path $FolderName -PathType Container)) {
    Write-Host "Error: Folder '$FolderName' does not exist."
    exit 1
}

$EnvExamplePath = Join-Path -Path $FolderName -ChildPath ".env.example"
$EnvPath = Join-Path -Path $FolderName -ChildPath ".env"

if (-not (Test-Path -Path $EnvExamplePath -PathType Leaf)) {
    Write-Host "Setup Completed Successfully."
    exit 1
}

if (Test-Path -Path $EnvPath -PathType Leaf) {
    Write-Host "Notice: .env already exists in '$FolderName'. Skipping to prevent overwriting."
    exit 0
}

# Function to generate a random alphanumeric string
function Get-RandomAlphanumericString {
    param([int]$Length)
    $chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    $bytes = [byte[]]::new($Length)
    $rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::Create()
    $rng.GetBytes($bytes)
    
    $result = ""
    for ($i = 0; $i -lt $Length; $i++) {
        $result += $chars[$bytes[$i] % $chars.Length]
    }
    return $result
}

$lines = Get-Content -Path $EnvExamplePath
$newLines = @()

foreach ($line in $lines) {
    if ($line -match "^([A-Za-z0-9_]+)=(.*)$" -and -not $line.StartsWith("#")) {
        $key = $matches[1]
        $val = $matches[2]
        
        $quote = ""
        $inner_val = $val
        
        if ($val -match '^"(.*)"$') {
            $quote = "`""
            $inner_val = $matches[1]
        } elseif ($val -match "^'(.*)'$") {
            $quote = "'"
            $inner_val = $matches[1]
        }
        
        if ($inner_val -match "^[A-Za-z0-9]+$" -and $inner_val.Length -ge 10) {
            $new_key = Get-RandomAlphanumericString -Length $inner_val.Length
            $newLines += "${key}=${quote}${new_key}${quote}"
        } else {
            $newLines += $line
        }
    } else {
        $newLines += $line
    }
}

# Write without BOM using UTF8
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
[System.IO.File]::WriteAllLines($EnvPath, $newLines, $Utf8NoBomEncoding)

Write-Host "Setup Completed Successfully. created .env in '$FolderName' with newly generated random keys."
