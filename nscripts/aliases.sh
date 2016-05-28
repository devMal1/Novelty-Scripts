#!/bin/bash

root="~/Novelty-Scripts/nscripts"

echo "Push all to github: push <commit message> <branch>"
alias push=". ~/Novelty-Scripts/nscripts/push_all.sh"

echo

echo "cd then ls: cdls <dir>"
alias cdls=". ~/Novelty-Scripts/nscripts/cdls.sh"

echo

echo "Up the tag/version of latest commit"
alias upTag=". {$root}/version_up.sh"
