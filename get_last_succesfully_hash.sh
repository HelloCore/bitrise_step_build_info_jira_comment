LAST_BUILD_REGEX='"commit_hash":"([A-z0-9]+)"'
URL="https://api.bitrise.io/v0.1/apps/$BITRISE_APP_SLUG/builds"
API_RESPONSE=$(curl -s --request GET --url "$URL" \
    --data-urlencode "branch=$BITRISE_GIT_BRANCH" \
    --data-urlencode "workflow=$BITRISE_TRIGGERED_WORKFLOW_TITLE" \
    --data-urlencode "status=1" \
    -H "accept: application/json" \
    -H "Authorization: $access_token")

echo "Calling URL: $URL"

if [[ $API_RESPONSE =~ $LAST_BUILD_REGEX ]]; then
    echo "FOUND LAST_COMMIT_SHA ${BASH_REMATCH[1]}"
    export LAST_COMMIT_SHA="${BASH_REMATCH[1]}"
else
    echo "LAST_COMMIT_SHA NOT FOUND"
    echo "RESPONSE"
    echo $API_RESPONSE    
    export LAST_COMMIT_SHA="HEAD"
fi