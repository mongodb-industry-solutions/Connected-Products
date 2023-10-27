#!/bin/bash

EDGE_MONGO_STATUS=$(docker ps -f "status=running" -f "name=.*mongodb_container.*" --format '{{.Status}}')
EDGE_MONGO_STATE=$(docker ps -a -f "name=.*mongodb_container.*" --format '{{.State}}')
if [ "${EDGE_MONGO_STATUS}" == "" ]; then
  echo "MongoDB container is not running. Status: ${EDGE_MONGO_STATE}"
  exit
fi

EDGE_MONGO_CONTAINER_NAME=$(docker ps -f "status=running" -f "name=.*mongodb_container.*" --format '{{.Names}}')
EDGE_MONGO_IS_PRIMARY=$(docker exec "${EDGE_MONGO_CONTAINER_NAME}" mongo --quiet --eval 'rs.isMaster().ismaster')
if [ "${EDGE_MONGO_IS_PRIMARY}" != true ]; then
  echo "MongoDB replica set initiating"
  exit
fi

EDGE_SERVER_STATUS=$(docker ps -f "status=running" -f "name=.*sync_server.*" --format '{{.Status}}')
EDGE_SERVER_STATE=$(docker ps -a -f "name=.*sync_server.*" --format '{{.State}}')
if [ "${EDGE_SERVER_STATUS}" == "" ]; then
  echo "Edge Server container is not running. Status: ${EDGE_SERVER_STATE}"
  exit
fi

EDGE_CLOUD_CURL_OUTPUT=$(curl -s -w "%{http_code}" http://localhost/api/client/v2.0/tiered-sync/status)
EDGE_CLOUD_CURL_STATUS_CODE=$(echo "${EDGE_CLOUD_CURL_OUTPUT}" | grep -o '...$')
EDGE_CLOUD_CURL_BODY=$(echo "${EDGE_CLOUD_CURL_OUTPUT}" | sed 's/...$//' | jq .)
if [ "${EDGE_CLOUD_CURL_STATUS_CODE}" == "200" ]; then
  echo "${EDGE_CLOUD_CURL_BODY}"
  exit
fi

echo "Edge Server container is running. Status: ${EDGE_SERVER_STATUS}"
