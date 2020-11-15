LAST_BUILD_REGEX='"commit_hash":"([A-z0-9]+)"'
URL="https://api.bitrise.io/v0.1/apps/$BITRISE_APP_SLUG/builds?branch=$BITRISE_GIT_BRANCH&workflow=$BITRISE_TRIGGERED_WORKFLOW_TITLE&status=1"
API_RESPONSE=$(curl -s --request GET --url "$URL" -H "accept: application/json" -H "Authorization: $access_token")

echo "Calling URL: $URL"

if [[ $API_RESPONSE =~ $LAST_BUILD_REGEX ]]; then
    export LAST_COMMIT_SHA="${BASH_REMATCH[1]}"
else
    export LAST_COMMIT_SHA="HEAD"
fi