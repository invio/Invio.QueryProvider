<#
.SYNOPSIS
  This is a helper function that runs a scriptblock and checks the PS variable $lastexitcode
  to see if an error occcured. If an error is detected then an exception is thrown.
  This function allows you to run command-line programs without having to
  explicitly check the $lastexitcode variable.
#>
function Exec
{
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory=1)][scriptblock]$cmd,
        [Parameter(Position=1,Mandatory=0)][string]$errorMessage = ($msgs.error_bad_command -f $cmd)
    )
    & $cmd
    if ($lastexitcode -ne 0) {
        throw ("Exec: " + $errorMessage)
    }
}

# Clone submodule repos
exec { & git submodule update --init --recursive -q }

if(Test-Path .\artifacts) { Remove-Item .\artifacts -Force -Recurse }
[void](New-Item artifacts -ItemType Directory)

$projects = @(
    "Invio.QueryProvider.Core\src\Invio.QueryProvider.Core\Invio.QueryProvider.Core.fsproj"
    "Invio.QueryProvider.Core\test\Invio.QueryProvider.Test\Invio.QueryProvider.Test.fsproj"
    "Invio.QueryProvider.Core\test\Invio.QueryProvider.Test.CSharp\Invio.QueryProvider.Test.CSharp.csproj"
    "Invio.QueryProvider.MySql\src\Invio.QueryProvider.MySql\Invio.QueryProvider.MySql.fsproj"
)

# The CD environment variable is missing on the windows build server
$env:PWD = Resolve-Path .

$artifacts = Resolve-Path artifacts

foreach ($project in $projects) {
    Write-Information "Building Project '$project'"
    exec { & dotnet pack $project -c Release -o $artifacts }
}

Write-Information "Running Tests"

exec { & dotnet test Invio.QueryProvider.Core\test\Invio.QueryProvider.Test\Invio.QueryProvider.Test.fsproj -c Release }

$appsettings_path = "./Invio.QueryProvider.MySql/test/Invio.QueryProvider.MySql.Test/config/appsettings.json"
if (-not (Test-Path $appsettings_path)) {
  Get-Content "$($appsettings_path).template" |
    ForEach-Object { $_.Replace("<<YOUR_MYSQL_PASSWORD_HERE>>", $env:mysql_password) } > `
    $appsettings_path
}

exec { & dotnet test Invio.QueryProvider.MySql\test\Invio.QueryProvider.MySql.Test\Invio.QueryProvider.MySql.Test.csproj -c Release }
