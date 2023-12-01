#!/usr/bin/env bash

SECRET_KEY_BASE=$(openssl genrsa 2048 | base64)
LAGO_RSA_PRIVATE_KEY=$(openssl genrsa 2048 | base64)
LAGO_ENCRYPTION_PRIMARY_KEY=$(openssl genrsa 2048 | base64)
LAGO_ENCRYPTION_DETERMINISTIC_KEY=$(openssl genrsa 2048 | base64)
LAGO_ENCRYPTION_KEY_DERIVATION_SALT=$(openssl genrsa 2048 | base64)

cat << EOT >> ./.env

SECRET_KEY_BASE="${SECRET_KEY_BASE}"
LAGO_RSA_PRIVATE_KEY="${LAGO_RSA_PRIVATE_KEY}"
LAGO_ENCRYPTION_PRIMARY_KEY="${LAGO_ENCRYPTION_PRIMARY_KEY}"
LAGO_ENCRYPTION_DETERMINISTIC_KEY="${LAGO_ENCRYPTION_DETERMINISTIC_KEY}"
LAGO_ENCRYPTION_KEY_DERIVATION_SALT="${LAGO_ENCRYPTION_KEY_DERIVATION_SALT}"
EOT

cat <<EOT > ./servers.json
{
    "Servers": {
        "1": {
            "Name": "local",
            "Group": "Servers",
            "Host": "172.17.0.1",
            "Port": 40211,
            "MaintenanceDB": "postgres",
            "SSLMode": "prefer",
            "Username": "postgres",
            "PassFile": "/pgpass"
        }
    }
}
EOT

docker buildx build . --output type=docker,name=elestio4test/lago-api:latest | docker load
