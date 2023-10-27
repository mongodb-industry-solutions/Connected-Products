#!/bin/bash

CLOUD_URL=https://realm.mongodb.com/api/client/v2.0

UPGRADE_ARG=$1

if [[ $UPGRADE_ARG != "--major" ]] && [[ $UPGRADE_ARG != "--minor" ]] && [[ $UPGRADE_ARG != "--latest" ]]; then
  echo "usage is ./upgrade.sh --major or ./upgrade.sh --minor or ./upgrade.sh --latest"
  exit 1
fi

if [[ $UPGRADE_ARG == "--major" ]]; then
  echo "major upgrades are not currently supported"
  exit 1
fi

if ! which jq ; then
  echo "jq was not found, please install jq"
  exit 1
fi

if ! SERVER_VERSION=$(./bin/get_edge_status.sh | jq -r ".version"); then
  source .env
fi

echo "Current version is ${SERVER_VERSION}"

TARGET="minor"
if [[ $UPGRADE_ARG == "--latest" ]]; then
  TARGET="latest"
fi

CLOUD_CURL_OUTPUT=$(curl -s -w "%{http_code}" ${CLOUD_URL}/tiered-sync/package/upgrade\?current_version\=${SERVER_VERSION}\&target\=${TARGET})
CLOUD_CURL_STATUS_CODE=$(echo "${CLOUD_CURL_OUTPUT}" | grep -o '...$')
CLOUD_CURL_BODY=$(echo "${CLOUD_CURL_OUTPUT}" | sed 's/...$//' | jq .)
if ! [ "${CLOUD_CURL_STATUS_CODE}" == "200" ]; then
  echo "Status code: ${CLOUD_CURL_STATUS_CODE}"
  echo "${CLOUD_CURL_BODY}"
  echo "Failed to get target for minor upgrade"
  exit 1
fi

UPGRADE_URL=$(echo "${CLOUD_CURL_BODY}" | jq -r ".url")
echo "Upgrade url: ${UPGRADE_URL}"
if [ "${UPGRADE_URL}" == "" ]; then
  echo "No available upgrades"
  exit
fi

./bin/fetch_server.sh $UPGRADE_URL $UPGRADE_ARG

