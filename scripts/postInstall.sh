#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."
sleep 60s;

target=$(docker-compose port api 3000)

url='http://'${target}'/graphql'

data='{
  "operationName": "signup",
  "variables": {
    "input": {
      "email": "'${ADMIN_EMAIL}'",
      "password": "'${ADMIN_PASSWORD}'",
      "organizationName": "main"
    }
  },
  "query":"mutation signup($input: RegisterUserInput!) {  registerUser(input: $input) {    token    user {      id      ...CurrentUser      __typename    }    __typename  }}fragment CurrentUser on User {  id  organizations {    id    timezone    __typename  }  __typename}"
}'

curl -X POST "$url" \
     -H 'accept: */*' \
     -H 'accept-language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7,he;q=0.6' \
     -H 'apollographql-client-name: lago-app' \
     -H 'apollographql-client-version: 0.5.0-alpha' \
     -H 'cache-control: no-cache' \
     -H 'content-type: application/json' \
     -H 'pragma: no-cache' \
     -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36' \
     -H 'x-lago-organization: null' \
     --data-raw "$data" \
     --compressed
