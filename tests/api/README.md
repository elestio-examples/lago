<a href="https://elest.io">
  <img src="https://elest.io/images/elestio.svg" alt="elest.io" width="150" height="75">
</a>

[![Discord](https://img.shields.io/static/v1.svg?logo=discord&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=Discord&message=community)](https://discord.gg/4T4JGaMYrD "Get instant assistance and engage in live discussions with both the community and team through our chat feature.")
[![Elestio examples](https://img.shields.io/static/v1.svg?logo=github&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=github&message=open%20source)](https://github.com/elestio-examples "Access the source code for all our repositories by viewing them.")
[![Blog](https://img.shields.io/static/v1.svg?color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=elest.io&message=Blog)](https://blog.elest.io "Latest news about elestio, open source software, and DevOps techniques.")

# Lago, verified and packaged by Elestio

[Lago](https://github.com/getlago/lago/) is an open-source software for metering and usage-based billing. It's the best alternative to Chargebee, Recurly or Stripe Billing for companies that need to handle complex billing logic.

<img src="https://github.com/elestio-examples/lago/raw/main/lago.png" alt="Lago" width="800">

Deploy a <a target="_blank" href="https://elest.io/open-source/lago">fully managed Lago</a> on <a target="_blank" href="https://elest.io/">elest.io</a> if you want automated backups, reverse proxy with SSL termination, firewall, automated OS & Software updates, and a team of Linux experts and open source enthusiasts to ensure your services are always safe, and functional.

[![deploy](https://github.com/elestio-examples/lago/raw/main/deploy-on-elestio.png)](https://dash.elest.io/deploy?source=cicd&social=dockerCompose&url=https://github.com/elestio-examples/Lago)

# Why use Elestio images?

- Elestio stays in sync with updates from the original source and quickly releases new versions of this image through our automated processes.
- Elestio images provide timely access to the most recent bug fixes and features.
- Our team performs quality control checks to ensure the products we release meet our high standards.

# Usage

## Git clone

You can deploy it easily with the following command:

    git clone https://github.com/elestio-examples/lago.git

Copy the .env file from tests folder to the project directory

    cp ./tests/.env ./.env

Edit the .env file with your own values.

Run the project with the following command

    docker-compose up -d

You can access the Web UI at: `http://your-domain:27712`

## Docker-compose

Here are some example snippets to help you get started creating a container.

        version: "3.8"

        services:
        db:
            image: elestio/postgres:15
            restart: always
            environment:
            POSTGRES_DB: ${POSTGRES_DB}
            POSTGRES_USER: ${POSTGRES_USER}
            POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
            PGDATA: /data/postgres
            PGPORT: 5432
            volumes:
            - ./storage/lago_postgres_data:/data/postgres
            ports:
            - 172.17.0.1:40211:5432

        redis:
            image: elestio/redis:7.0
            restart: always
            command: ["redis-server", "--requirepass", "${REDIS_PASSWORD}"]
            volumes:
            - ./storage/lago_redis_data:/data
            ports:
            - 172.17.0.1:31542:6379

        api:
            image: elestio4test/lago-api:${SOFTWARE_VERSION_TAG}
            restart: always
            depends_on:
            - db
            - redis
            command: ["./scripts/start.sh"]
            environment:
            - LAGO_API_URL=https://${DOMAIN}:34079
            - DATABASE_URL=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}
            - REDIS_URL=redis://${REDIS_HOST}:${REDIS_PORT}
            - REDIS_PASSWORD=${REDIS_PASSWORD}
            - SECRET_KEY_BASE=${SECRET_KEY_BASE}
            - RAILS_ENV=production
            - RAILS_LOG_TO_STDOUT=${LAGO_RAILS_STDOUT}
            - SENTRY_DSN=${SENTRY_DSN}
            - LAGO_FRONT_URL=https://${DOMAIN}
            - RSA_PRIVATE_KEY=${LAGO_RSA_PRIVATE_KEY}
            - LAGO_RSA_PRIVATE_KEY=${LAGO_RSA_PRIVATE_KEY}
            - LAGO_SIDEKIQ_WEB=${LAGO_SIDEKIQ_WEB}
            - ENCRYPTION_PRIMARY_KEY=${LAGO_ENCRYPTION_PRIMARY_KEY}
            - ENCRYPTION_DETERMINISTIC_KEY=${LAGO_ENCRYPTION_DETERMINISTIC_KEY}
            - ENCRYPTION_KEY_DERIVATION_SALT=${LAGO_ENCRYPTION_KEY_DERIVATION_SALT}
            - LAGO_USE_AWS_S3=${LAGO_USE_AWS_S3}
            - LAGO_AWS_S3_ACCESS_KEY_ID=${LAGO_AWS_S3_ACCESS_KEY_ID:-azerty123456}
            - LAGO_AWS_S3_SECRET_ACCESS_KEY=${LAGO_AWS_S3_SECRET_ACCESS_KEY:-azerty123456}
            - LAGO_AWS_S3_REGION=${LAGO_AWS_S3_REGION:-us-east-1}
            - LAGO_AWS_S3_BUCKET=${LAGO_AWS_S3_BUCKET:-bucket}
            - LAGO_AWS_S3_ENDPOINT=${LAGO_AWS_S3_ENDPOINT}
            - LAGO_USE_GCS=${LAGO_USE_GCS:-false}
            - LAGO_GCS_PROJECT=${LAGO_GCS_PROJECT:-}
            - LAGO_GCS_BUCKET=${LAGO_GCS_BUCKET:-}
            - LAGO_PDF_URL=${LAGO_PDF_URL:-http://pdf:3000}
            - LAGO_REDIS_CACHE_URL=redis://${LAGO_REDIS_CACHE_HOST}:${LAGO_REDIS_CACHE_PORT}
            - LAGO_REDIS_CACHE_PASSWORD=${LAGO_REDIS_CACHE_PASSWORD}
            - LAGO_DISABLE_SEGMENT=${LAGO_DISABLE_SEGMENT}
            - LAGO_OAUTH_PROXY_URL=https://proxy.getlago.com
            - LAGO_LICENSE=${LAGO_LICENSE:-}
            volumes:
            - ./storage/lago_storage_data:/app/storage
            # If using GCS, you need to put the credentials keyfile here
            #- gcs_keyfile.json:/app/gcs_keyfile.json
            ports:
            - 172.17.0.1:17840:3000

        front:
            image: elestio4test/lago-front:${SOFTWARE_VERSION_TAG}
            restart: always
            # Use this command if you want to use SSL with Let's Encrypt
            # command: "/bin/sh -c 'while :; do sleep 6h & wait $${!}; nginx -s reload; done & nginx -g \"daemon off;\"'"
            depends_on:
            - api
            environment:
            - API_URL=https://${DOMAIN}:34079
            - APP_ENV=production
            - CODEGEN_API=https://${DOMAIN}:34079
            - LAGO_DISABLE_SIGNUP=${LAGO_DISABLE_SIGNUP}
            - LAGO_OAUTH_PROXY_URL=https://proxy.getlago.com
            - SENTRY_DSN=${SENTRY_DSN_FRONT}
            ports:
            - 172.17.0.1:34746:80
            #  - 443:443
            # Using SSL with Let's Encrypt
            # volumes:
            #   - ./extra/nginx-letsencrypt.conf:/etc/nginx/conf.d/default.conf
            #   - ./extra/certbot/conf:/etc/letsencrypt
            #   - ./extra/certbot/www:/var/www/certbot
            # Using SSL with self signed certificates
            # volumes:
            #   - ./extra/nginx-selfsigned.conf:/etc/nginx/conf.d/default.conf
            #   - ./extra/ssl/nginx-selfsigned.crt:/etc/ssl/certs/nginx-selfsigned.crt
            #   - ./extra/ssl/nginx-selfsigned.key:/etc/ssl/private/nginx-selfsigned.key
            #   - ./extra/ssl/dhparam.pem:/etc/ssl/certs/dhparam.pem

        # Only used for SSL support with Let's Encrypt
        # certbot:
        #   image: certbot/certbot
        #   entrypoint: "/bin/sh -c 'trap exit TERM; while :; do certbot renew; sleep 12h & wait $${!}; done;'"
        #   volumes:
        #     - ./extra/certbot/conf:/etc/letsencrypt
        #     - ./extra/certbot/www:/var/www/certbot

        api-worker:
            image: elestio4test/lago-api:${SOFTWARE_VERSION_TAG}
            restart: always
            depends_on:
            - api
            command: ["./scripts/start.worker.sh"]
            environment:
            - LAGO_API_URL=https://${DOMAIN}:34079
            - DATABASE_URL=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}
            - REDIS_URL=redis://${REDIS_HOST}:${REDIS_PORT}
            - REDIS_PASSWORD=${REDIS_PASSWORD}
            - SECRET_KEY_BASE=${SECRET_KEY_BASE}
            - RAILS_ENV=production
            - RAILS_LOG_TO_STDOUT=${LAGO_RAILS_STDOUT}
            - SENTRY_DSN=${SENTRY_DSN}
            - LAGO_RSA_PRIVATE_KEY=${LAGO_RSA_PRIVATE_KEY}
            - RSA_PRIVATE_KEY=${LAGO_RSA_PRIVATE_KEY}
            - ENCRYPTION_PRIMARY_KEY=${LAGO_ENCRYPTION_PRIMARY_KEY}
            - ENCRYPTION_DETERMINISTIC_KEY=${LAGO_ENCRYPTION_DETERMINISTIC_KEY}
            - ENCRYPTION_KEY_DERIVATION_SALT=${LAGO_ENCRYPTION_KEY_DERIVATION_SALT}
            - LAGO_FRONT_URL=https://${DOMAIN}
            - LAGO_USE_AWS_S3=${LAGO_USE_AWS_S3}
            - LAGO_AWS_S3_ACCESS_KEY_ID=${LAGO_AWS_S3_ACCESS_KEY_ID:-azerty123456}
            - LAGO_AWS_S3_SECRET_ACCESS_KEY=${LAGO_AWS_S3_SECRET_ACCESS_KEY:-azerty123456}
            - LAGO_AWS_S3_REGION=${LAGO_AWS_S3_REGION:-us-east-1}
            - LAGO_AWS_S3_BUCKET=${LAGO_AWS_S3_BUCKET:-bucket}
            - LAGO_AWS_S3_ENDPOINT=${LAGO_AWS_S3_ENDPOINT}
            - LAGO_USE_GCS=${LAGO_USE_GCS}
            - LAGO_GCS_PROJECT=${LAGO_GCS_PROJECT:-}
            - LAGO_GCS_BUCKET=${LAGO_GCS_BUCKET:-}
            - LAGO_PDF_URL=${LAGO_PDF_URL:-http://pdf:3000}
            - LAGO_REDIS_CACHE_URL=redis://${LAGO_REDIS_CACHE_HOST}:${LAGO_REDIS_CACHE_PORT}
            - LAGO_REDIS_CACHE_PASSWORD=${LAGO_REDIS_CACHE_PASSWORD}
            - LAGO_DISABLE_SEGMENT=${LAGO_DISABLE_SEGMENT}
            volumes:
            - ./storage/lago_storage_data:/app/storage

        api-clock:
            image: elestio4test/lago-api:${SOFTWARE_VERSION_TAG}
            restart: always
            depends_on:
            - api
            command: ["./scripts/start.clock.sh"]
            environment:
            - LAGO_API_URL=https://${DOMAIN}:34079
            - DATABASE_URL=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}
            - REDIS_URL=redis://${REDIS_HOST}:${REDIS_PORT}
            - REDIS_PASSWORD=${REDIS_PASSWORD}
            - SECRET_KEY_BASE=${SECRET_KEY_BASE}
            - RAILS_ENV=production
            - RAILS_LOG_TO_STDOUT=${LAGO_RAILS_STDOUT}
            - SENTRY_DSN=${SENTRY_DSN}
            - LAGO_RSA_PRIVATE_KEY=${LAGO_RSA_PRIVATE_KEY}
            - RSA_PRIVATE_KEY=${LAGO_RSA_PRIVATE_KEY}
            - ENCRYPTION_PRIMARY_KEY=${LAGO_ENCRYPTION_PRIMARY_KEY}
            - ENCRYPTION_DETERMINISTIC_KEY=${LAGO_ENCRYPTION_DETERMINISTIC_KEY}
            - ENCRYPTION_KEY_DERIVATION_SALT=${LAGO_ENCRYPTION_KEY_DERIVATION_SALT}

        pdf:
            image: getlago/lago-gotenberg:7
            restart: always

        pgadmin4:
            image: dpage/pgadmin4:latest
            restart: always
            environment:
            PGADMIN_DEFAULT_EMAIL: ${ADMIN_EMAIL}
            PGADMIN_DEFAULT_PASSWORD: ${ADMIN_PASSWORD}
            PGADMIN_LISTEN_PORT: 8080
            ports:
            - "172.17.0.1:15683:8080"
            volumes:
            - ./servers.json:/pgadmin4/servers.json



# Maintenance

## Logging

The Elestio Lago Docker image sends the container logs to stdout. To view the logs, you can use the following command:

    docker-compose logs -f

To stop the stack you can use the following command:

    docker-compose down

## Backup and Restore with Docker Compose

To make backup and restore operations easier, we are using folder volume mounts. You can simply stop your stack with docker-compose down, then backup all the files and subfolders in the folder near the docker-compose.yml file.

Creating a ZIP Archive
For example, if you want to create a ZIP archive, navigate to the folder where you have your docker-compose.yml file and use this command:

    zip -r myarchive.zip .

Restoring from ZIP Archive
To restore from a ZIP archive, unzip the archive into the original folder using the following command:

    unzip myarchive.zip -d /path/to/original/folder

Starting Your Stack
Once your backup is complete, you can start your stack again with the following command:

    docker-compose up -d

That's it! With these simple steps, you can easily backup and restore your data volumes using Docker Compose.

# Links

- <a target="_blank" href="https://github.com/getlago/lago/">Lago Github repository</a>

- <a target="_blank" href="https://docs.getlago.com/guide/introduction/welcome-to-lago">Lago documentation</a>

- <a target="_blank" href="https://github.com/elestio-examples/lago">Elestio/lago Github repository</a>
