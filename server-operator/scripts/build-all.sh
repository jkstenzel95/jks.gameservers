#!/bin/bash

set -eo pipefail

# set repo filepath here

echo repo: $repo
pushd "$repo"

baseIntDir=${BUILD_ARTIFACTS_DIRECTORY:-$repo}/___intermediate/
baseOutDir=${BUILD_ARTIFACTS_DIRECTORY:-$repo}/___output/

echo BaseIntDir="$baseIntDir"
echo BaseOutDir="$baseOutDir"

# do I need to generate a build number here?

# Todo: add version number, branch name
find src -type f -name "*.csproj" | while read -r x; do dotnet build "${x}" -c Release -p:BaseOutDir="$baseOutDir" -p:BaseIntDir="$baseIntDir" -p:BUILD_BUILDNUMBER="TODO" -p:BUILD_SOURCEBRANCHNAME="TODO" || exit 1; done
find test -type f -name "*.csproj" | while read -r x; do dotnet build "${x}" -c Release -p:BUILD_BUILDNUMBER="TODO" -p:BUILD_SOURCEBRANCHNAME="TODO" -p:CollectCoverage=true -p:CoverletOutputFormat=opencover || exit 1; done
find src -type f -name "*.csproj" | while read x; do dotnet publish -c Release -p:BaseOutDir="$baseOutDir" -p:BaseIntDir="$baseIntDir" -p:BUILD_BUILDNUMBER="TODO" -p:BUILD_SOURCEBRANCHNAME="TODO" "$x" || exit 1; done

popd