#!/usr/bin/env bash

# This file contains a lot of hacks. I'm new to bash.

command -v curl > /dev/null >&1 || {
	echo "cURL not installed! Aborting.";
	exit 1;
}

Username=$1;
RepositoryName=$2;
BranchName=`git rev-parse --abbrev-ref HEAD`;

if [ "$Username" = "" ]
	then
	echo "Usage: $0 GitHubUsername [RepositoryName]";
	exit 2;
fi

if [ "$RepositoryName" = "" ]
	then
	RepositoryName="ValkyrieFramework";
fi

printf "Trying to build current branch: \x1b[33;1m$Username/$RepositoryName\x1b[0m:\x1b[34;1m$BranchName\x1b[0m\n";
echo "This may take a while.";

curl -s --url "http://gskw.noip.me:999/build/$Username/$RepositoryName/$BranchName";

printf "\nModel built!";
