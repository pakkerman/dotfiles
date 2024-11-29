#!/bin/bash

# FZF with git add and diff show in the preview
# return will add item into staging
echo $(pwd)
git status -s | sed -E 's/[ A-Z]{3}//' | fzf --preview 'git diff --color {}' --preview-window=top | xargs git add
