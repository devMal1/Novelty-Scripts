#!/bin/bash

root="~/Novelty-Scripts/nscripts"

echo "Push all to github: push <commit message> <branch>"
alias push=". ${root}/push_all.sh"

echo

echo "cd then ls: cdls <dir>"
alias cdls=". ${root}/cdls.sh"

echo

echo "Up the tag/version of latest commit: uptag "
alias uptag=". ${root}/version_up.sh"
