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
exec { & git submodule update --init --recursive }

if(Test-Path .\artifacts) { Remove-Item .\artifacts -Force -Recurse }
New-Item artifacts -ItemType Directory

exec { & dotnet restore }
exec { & dotnet build }

$revision = @{ $true = $env:APPVEYOR_BUILD_NUMBER; $false = 1 }[$env:APPVEYOR_BUILD_NUMBER -ne $NULL];
$revision = "{0:D4}" -f [convert]::ToInt32($revision, 10)

exec { & dotnet test Invio.QueryProvider.Core\test\Invio.QueryProvider.Test\Invio.QueryProvider.Test.fsproj -c Release }
exec { & dotnet test Invio.QueryProvider.MySql\test\Invio.QueryProvider.MySql.Test\Invio.QueryProvider.MySql.Test.csproj -c Release }

exec { & dotnet pack Invio.QueryProvider.Core\src\Invio.QueryProvider.Core\Invio.QueryProvider.Core.fsproj -c Release -o ..\..\..\artifacts }
exec { & dotnet pack Invio.QueryProvider.Core\test\Invio.QueryProvider.Test\Invio.QueryProvider.Test.csproj -c Release -o ..\..\..\artifacts }
exec { & dotnet pack Invio.QueryProvider.Core\test\Invio.QueryProvider.Test.CSharp\Invio.QueryProvider.Test.CSharp.csproj -c Release -o ..\..\..\artifacts }
exec { & dotnet pack Invio.QueryProvider.MySql\src\Invio.QueryProvider.MySql\Invio.QueryProvider.MySql.fsproj -c Release -o ..\..\..\artifacts }
