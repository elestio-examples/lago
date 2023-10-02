#set env vars
set -o allexport; source .env; set +o allexport;


SECRET_KEY_BASE_TEMP=$(openssl rand -hex 32)
LAGO_RSA_PRIVATE_KEY_TEMP=$(openssl rand -hex 32)
LAGO_ENCRYPTION_PRIMARY_KEY=$(openssl rand -hex 32)
LAGO_ENCRYPTION_DETERMINISTIC_KEY=$(openssl rand -hex 32)
LAGO_ENCRYPTION_KEY_DERIVATION_SALT=$(openssl rand -hex 32)

SECRET_KEY_BASE=$(echo -n "$SECRET_KEY_BASE_TEMP" | xxd -r -p | base64)
LAGO_RSA_PRIVATE_KEY=$(echo -n "$LAGO_RSA_PRIVATE_KEY_TEMP" | xxd -r -p | base64)

cat << EOT >> ./.env

SECRET_KEY_BASE=${SECRET_KEY_BASE}
LAGO_RSA_PRIVATE_KEY=${LAGO_RSA_PRIVATE_KEY}
LAGO_ENCRYPTION_PRIMARY_KEY=${LAGO_ENCRYPTION_PRIMARY_KEY}
LAGO_ENCRYPTION_DETERMINISTIC_KEY=${LAGO_ENCRYPTION_DETERMINISTIC_KEY}
LAGO_ENCRYPTION_KEY_DERIVATION_SALT=${LAGO_ENCRYPTION_KEY_DERIVATION_SALT}
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