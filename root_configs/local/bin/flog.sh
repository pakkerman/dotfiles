#!/bin/bash

git log --oneline | fzf --multi --preview 'git show --color {+1}' --preview-label logs


