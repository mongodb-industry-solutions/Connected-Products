build/edge_config.json: config.json
	mkdir -p build

	cat config.tmpl | jq --argjson config '$(shell cat config.json)' \
		".edge.clientAppId = \$$config.clientAppId | \
		.edge.cloudSyncServerAuthSecret = \$$config.cloudSyncServerAuthSecret | \
		.api.tls = \$$config.tls | \
		.edge.query = \$$config.query | \
        .edge.cloudSyncServerBaseURL = \$$config.cloudSyncServerBaseURL" > build/edge_config.json

	sed 's/localhost:80/$(shell cat config.json | jq -r .hostname)/g' build/edge_config.json > edge_config.json && \
	mv -f edge_config.json build/

.PHONY: config
config: build/edge_config.json

.PHONY: status
status:
	@ ./bin/get_edge_status.sh

.PHONY: start up stop down clean
start up: config
	docker-compose up -d
stop down:
	docker-compose stop
clean: stop
	rm -rf build
	# remove containers and anonymous volumes
	docker-compose rm -vf
	# remove mongodb data container if it exists
	-docker volume rm -f $$(docker volume ls | grep _mongodb_data_container | awk '{print $$2}')

.PHONY: upgrade-minor upgrade-major upgrade-force
upgrade-minor: bin/upgrade.sh
	@ ./bin/upgrade.sh --minor
upgrade-major: bin/upgrade.sh
	@ ./bin/upgrade.sh --major
upgrade-force: bin/upgrade.sh
	@ ./bin/upgrade.sh --latest
