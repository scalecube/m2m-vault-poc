set -u

# Service consumer entity token
ENTITY_TOKEN=$1
# Access request is $provider_entity.$consumer_entity.$access
ACCESS_REQUEST_ID=$2

echo ">>> generating jwt tokent on access request: $ACCESS_REQUEST_ID"
curl --header "X-Vault-Token: $ENTITY_TOKEN" $VAULT_ADDR/v1/identity/oidc/token/$ACCESS_REQUEST_ID
