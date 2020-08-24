#!/bin/bash

if [ ! "$BRANCH" = "" ];
then
  GIT_BRANCH=$BRANCH
else
  # local
  GIT_BRANCH="$(git branch | grep \* | cut -d ' ' -f2)"
fi

if [ "$GIT_BRANCH" == "master" ]; then
  ACCOUNT_NAME="prod"
elif [ "$GIT_BRANCH" == "test" ]; then
  ACCOUNT_NAME="test"
elif [ "$GIT_BRANCH" == "qa" ]; then
  ACCOUNT_NAME="qa"
else
  ACCOUNT_NAME="dev"
fi

echo $ACCOUNT_NAME