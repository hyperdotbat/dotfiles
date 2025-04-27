#!/bin/bash

PROMPT_COMMAND='
PS1_CMD1="";
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null);
    PS1_CMD1="$BRANCH";

    if [ -z "$BRANCH" ]; then
        BRANCH=$(git rev-parse --short HEAD 2>/dev/null);
	PS1_CMD1="($BRANCH)"
    fi
fi
echo';

PS1='\[\e[90m\][\[\e[32m\]\u\[\e[36m\]@\[\e[34m\]\h\[\e[90m\]]\[\e[33m\] \w \[\e[35;1m\]${PS1_CMD1}\n\[\e[0;31m\]λ\[\e[0m\] ';
#PS1='\[\e[90m\][\e[34m\]\h\[\e[90m\]]\[\e[33m\] \w \[\e[35;1m\]${PS1_CMD1}\n\[\e[0;31m\]λ\[\e[0m\] ';
