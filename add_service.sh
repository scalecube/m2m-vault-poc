set -u

SERVICE=$1

echo "### creating service entity: $SERVICE"
eval `vault write -output-curl-string auth/userpass/users/$SERVICE password=123`

# Login and get entity id.
LOGIN_CMD=`vault login -output-curl-string -method=userpass username=$SERVICE password=123`
ENTITY_ID=$(eval $LOGIN_CMD | jq .auth.entity_id | tr -d '"')
ENTITY_TOKEN=$(eval $LOGIN_CMD | jq .auth.client_token | tr -d '"')
ENTITY_NAME=$(curl --header "X-Vault-Token: $VAULT_TOKEN" $VAULT_ADDR/v1/identity/entity/id/$ENTITY_ID | jq .data.name | tr -d '"')

# Register service_provider policy from hcl file.
vault policy write service_provider service_provider.hcl

# Set service_provider policy.
echo "{\"policies\":[\"service_provider\"]}" > payload.json
curl --header "X-Vault-Token: $VAULT_TOKEN" --request POST --data @payload.json $VAULT_ADDR/v1/identity/entity/id/$ENTITY_ID

echo "### created service entity: $SERVICE, entity: $ENTITY_NAME/$ENTITY_ID, token: $ENTITY_TOKEN"
