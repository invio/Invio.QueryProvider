#!/usr/bin/env bash

#exit if any command fails
set -e



artifactsFolder="$(pwd)/artifacts"

if [ -d $artifactsFolder ]; then
  rm -R $artifactsFolder
fi

mkdir $artifactsFolder

projects=( \
    "Invio.QueryProvider.Core/src/Invio.QueryProvider.Core/Invio.QueryProvider.Core.fsproj" \
    "Invio.QueryProvider.Core/test/Invio.QueryProvider.Test/Invio.QueryProvider.Test.fsproj" \
    "Invio.QueryProvider.Core/test/Invio.QueryProvider.Test.CSharp/Invio.QueryProvider.Test.CSharp.csproj" \
    "Invio.QueryProvider.MySql/src/Invio.QueryProvider.MySql/Invio.QueryProvider.MySql.fsproj" \
    "Invio.QueryProvider.MySql/test/Invio.QueryProvider.MySql.Test/Invio.QueryProvider.MySql.Test.csproj" \
  )

for proj in ${projects[@]}; do
  echo Building $proj
  dotnet build $proj -c Debug
  dotnet pack $proj -c Release -o $artifactsFolder
done
