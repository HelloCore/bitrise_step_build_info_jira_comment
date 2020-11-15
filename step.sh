#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

red=$'\e[31m'
green=$'\e[32m'
blue=$'\e[34m'
magenta=$'\e[35m'
cyan=$'\e[36m'
reset=$'\e[0m'

LAST_COMMIT_SHA="HEAD"
CURRENT_COMMIT_SHA=`git log -1 --pretty=format:"%H"`

. ./get_last_succesfully_hash.sh

echo ""
echo "------------"
echo "LAST_COMMIT_SHA: $LAST_COMMIT_SHA"
echo "CURRENT_SHA: $CURRENT_COMMIT_SHA"
echo "------------"
echo ""

./find_issue_logs.sh "$LAST_COMMIT_SHA" "$TARGET_COMMIT_SHA"

escaped_jira_comment=$(echo "$jira_comment" | perl -pe 's/\n/\\n/g' | sed 's/.\{2\}$//')

create_comment_data()
{
cat<<EOF
{
"body": "${escaped_jira_comment}"
}
EOF
}

comment_data="$(create_comment_data)"

echo "${blue}⚡ Posting to:"

if [ -f $FILTERED_ISSUE_PATH ]
then
    while IFS= read -r issue_no
    do  
		res="$(curl --write-out %{response_code} --silent --output /dev/null --user $jira_user:$jira_token --request POST --header "Content-Type: application/json" --data-binary "${comment_data}" --url https://${backlog_default_url}/rest/api/2/issue/${issue_no}/comment)"
		if test "$res" == "201"
		then
			echo $'\t'$'\t'"${green}✅ Success!${reset}"
		else
			echo $'\t'$'\t'"${red}❗️ Failed${reset}"
			echo $res
		fi
    done <"$FILTERED_ISSUE_PATH"
else
    echo "Couldn't detect any cards."
fi
