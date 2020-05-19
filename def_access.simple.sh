set -u

ACCESS_ID=$1
TEMPLATE_DATA=$2
KEY=$ACCESS_ID
ROLE=$ACCESS_ID

echo "*** granting access: [$ACCESS_ID]"

# Register access_request policy which allows to generate oidc token.
echo "path \"identity/oidc/token/$ACCESS_ID\" {capabilities=[\"read\"]}" > payload.hcl
vault policy write $ACCESS_ID-id-token-policy payload.hcl

# Create oidc/role
echo "{\"key\": \"$KEY\", \"template\": \"$TEMPLATE_DATA\", \"ttl\": \"1m\"}" > payload.json
curl --header "X-Vault-Token: $VAULT_TOKEN" --request POST --data @payload.json $VAULT_ADDR/v1/identity/oidc/role/$ROLE

# Create oidc/key
echo "{\"allowed_client_ids\": \"*\", \"verification_ttl\": \"1m\", \"rotation_period\": \"1m\"}" > payload.json
curl --header "X-Vault-Token: $VAULT_TOKEN" --request POST --data @payload.json $VAULT_ADDR/v1/identity/oidc/key/$KEY

echo "*** access granted!"
