#!/bin/bash
ROOT_PATH="$(dirname "$0")"

FILTERED_ISSUE_PATH="/tmp/tmp-filtered-issue.txt"
CURRENT_COMMIT_SHA=$1
LAST_SUCCESS_COMMIT_SHA=$2

REGEX_ISSUE="${project_prefix}\([0-9]\+\)"

echo "- FINDING ISSUE LOG FROM GIT"

if [ -f $FILTERED_ISSUE_PATH ]
then
    rm $FILTERED_ISSUE_PATH
fi

ISSUE_LIST=`git log --pretty="%s %b" $LAST_SUCCESS_COMMIT_SHA..$CURRENT_COMMIT_SHA | grep -o "$REGEX_ISSUE"`

for line in $ISSUE_LIST
do
    $ROOT_PATH/add_if_not_exists.sh "$line" $FILTERED_ISSUE_PATH
done

echo "---- FOUND ISSUES ----"
echo $ISSUE_LIST
echo "----------------------"
echo ""
