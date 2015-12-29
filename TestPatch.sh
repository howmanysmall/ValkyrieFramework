#!/usr/bin/env bash

PATCHCMD=`git diff --cached`;
BRANCH=`git rev-parse --abbrev-ref HEAD`;
OWNER=$1;

curl https://ci.crescentcode.net/test_patch/$OWNER/$BRANCH --data-binary @- <<< "$PATCHCMD"
