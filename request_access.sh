set -u

PROVIDER_ENTITY=$1
CONSUMER_ENTITY=$2
ACCESS=$3
ACCESS_REQUEST_ID=$PROVIDER_ENTITY.$CONSUMER_ENTITY.$ACCESS

echo "*** creating access request on: [$ACCESS] from consumer: $CONSUMER_ENTITY to provider: $PROVIDER_ENTITY"

# Register access_request policy which allows to generate oidc token.
echo "path \"identity/oidc/token/$ACCESS_REQUEST_ID\" {capabilities=[\"create\", \"read\"]}" > payload.hcl
vault policy write $ACCESS_REQUEST_ID payload.hcl

# Update service consumer entity with access_request policy.
echo "{\"policies\":[\"$ACCESS_REQUEST_ID\"]}" > payload.json
curl --header "X-Vault-Token: $VAULT_TOKEN" --request POST --data @payload.json $VAULT_ADDR/v1/identity/entity/id/$CONSUMER_ENTITY

echo '*** created access request!'
