#!/usr/bin/env bash

#exit if any command fails
set -e

projects=( \
    "./Invio.QueryProvider.Core/test/Invio.QueryProvider.Test/Invio.QueryProvider.Test.fsproj" \
    "./Invio.QueryProvider.Core/test/Invio.QueryProvider.Test.CSharp/Invio.QueryProvider.Test.CSharp.csproj" \
    "./Invio.QueryProvider.MySql/test/Invio.QueryProvider.MySql.Test/Invio.QueryProvider.MySql.Test.csproj" \
  )

./Invio.QueryProvider.MySql/test/Invio.QueryProvider.MySql.Test/configure.sh

for proj in ${projects[@]}; do
  dotnet test $proj \
    --configuration Release \
    /p:CollectCoverage="true" \
    /p:CoverletOutputFormat=\"json,opencover\" \
    /p:CoverletOutput="../../../coverage/" \
    /p:MergeWith="../../../coverage/coverage.json"
done
