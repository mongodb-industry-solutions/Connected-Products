Version: 0.7.1
# Getting Started with Atlas Device Sync: Edge Server

## Background

Atlas Device Sync Edge allows synchronization across a local network for devices that are disconnected from the internet. Devices will
connect to and synchronize with a local edge server, and that server, when connected to the internet, will in turn 
synchronize with the MongoDB Cloud Sync Server.

## Requirements

### Hardware
Hardware specifications coming soon.

### Software
The host running the edge server must have `docker`, `docker-compose`, `make` and `jq` installed. On an ubuntu machine, this can be done with:

```
sudo apt update
sudo apt-get install docker docker-compose make jq
```

Additionally, this host must be able to listen on port 80.

## Starting the Edge Server

1. Start by creating a new Realm App on https://realm.mongodb.com/. Enable Sync.

2. Reach out to the MongoDB team with your App ID to request that Edge be enabled. They will provide you with a secret token.

3. Update config.json with your app ID, your query (using at least one table from your app's schema), the token from step 2, and the hostname of the machine the sync server will be deployed on.

4. Start the server (you may need to be root or add your user account to the docker group)
    ```
    make up
    ```

5. Set the `hostname` in your application code to point to the hostname of your Edge Server.

## Edge Wireprotocol Server

### Description
The edge server allows wireprotocol connections where reads and writes are synchronized with the Atlas Cluster used by App Services Device Sync for the application.

### Connecting
The wireprotocol server is on by default and can be connected to via the host machine (`EDGE_SERVER_HOSTNAME`) on port `27021` using the MongoDB URI `mongodb://EDGE_SERVER_HOSTNAME:27021`.

### Supported commands
- find, findOne
- update, updateOne, updateMany (upserts are not supported)
- deleteOne, deleteMany

## Debugging

### Status / Logs

At any time, run 
```
make status
```
to see the status of the edge server. For further detail, view the logs with
```
docker-compose logs -f sync_server
```

### Stop

To stop the edge server, run 
```
make down
```

### Clean

To wipe all data and start over, run 
```
make clean
```
This will reset the edge server.

## Limitations

1. Many config changes on the cloud (including change of schema, change of permissions, etc) will not propagate correctly
to the edge server. If this happens, you must run `make clean up` to wipe all state from the edge server and start over.

## License

This product is not to be used in production and can only be used in any capacity with explicit written permission from MongoDB.
