#!/bin/bash

if [ "$#" -gt 0 ] && [[ "$1" =~ ^https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(\/.*)?$ ]]; then
        # Shut down the server if it is running
        make stop
        URL=$1

        # Preserve previous files
        mkdir .backup
        cp -r bin certs config.json config.tmpl docker-compose.yml Makefile .backup/

        # Fetch the tar file
        curl ${URL} -o edge_server.tgz
        # Extract it in the current directory
        tar -xvzf edge_server.tgz

        # If this is a major upgrade, then preserve the new config file structure as a new file.
        # Otherwise, delete the new config.json to preserve the old one.
        if [[ $2 == "--major" ]]; then
                mv edge_server/config.json edge_server/new_config_template.json
        else
                rm edge_server/config.json
        fi
        # Delete certs to preserve any existing certs
        rm -rf edge_server/certs
        # Delete bins to overwrite them (mv won't overwrite a nonempty dir)
        # also delete the build directory to rewrite it with new assets after upgrade
        rm -rf bin/* build
        # Move and overwrite everything from the new edge_server/ dir to current dir
        mv edge_server/* .
        # Cleanup
        rm -rf edge_server.tgz edge_server
       # TODO: run the upgrade. This will be used for major upgrades and will call
       # a script in the new package accomplish tasks such as upgrade the config file
       # and preserve the previous values.
       echo "Done."


else
    echo "Usage: ./fetch_server.sh <URL>"
fi


