#!/bin/bash


set -o errexit


usage()
{
	echo "Usage: $0 OLD_EMAIL OLD_NAME NEW_EMAIL NEW_NAME"
}


[ "$#" -ne "4" ] && usage && exit 1

OLD_EMAIL=$1
OLD_NAME=$2
NEW_EMAIL=$3
NEW_NAME="$4"

git filter-branch --env-filter '

if [ "$GIT_COMMITTER_EMAIL" = "'"$OLD_EMAIL"'" ]
then
	export GIT_COMMITTER_NAME="'"$NEW_NAME"'"
	export GIT_COMMITTER_EMAIL="'"$NEW_EMAIL"'"
fi
if [ "$GIT_AUTHOR_EMAIL" = "'"$OLD_EMAIL"'" ]
then
	export GIT_AUTHOR_NAME="'"$NEW_NAME"'"
	export GIT_AUTHOR_EMAIL="'"$NEW_EMAIL"'"
fi
' --tag-name-filter cat -- --branches --tags


