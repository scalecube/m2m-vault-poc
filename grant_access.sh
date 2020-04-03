set -u

PROVIDER_ENTITY=$1
CONSUMER_ENTITY=$2
ACCESS=$3
KEY=$PROVIDER_ENTITY.$CONSUMER_ENTITY.$ACCESS
ROLE=$PROVIDER_ENTITY.$CONSUMER_ENTITY.$ACCESS

echo "*** granting access: [$ACCESS] from provider: $PROVIDER_ENTITY to consumer: $CONSUMER_ENTITY"

DATA="eyJhbGxvd2VkX2FjdGlvbnMiOlsibmV3SW5zdHJ1bWVudCIsImFzc2lnbkNhbGVuZGFyIiwiYXNzaWduQ2JyIiwib3BlcmF0aW9uRXZlbnRzIl19"
echo "{\"key\":\"$KEY\", \"template\":\"$DATA\"}" > payload.json
curl --header "X-Vault-Token: $VAULT_TOKEN" --request POST --data @payload.json $VAULT_ADDR/v1/identity/oidc/role/$ROLE

CLIENT_ID=$(curl --header "X-Vault-Token: $VAULT_TOKEN" $VAULT_ADDR/v1/identity/oidc/role/$ROLE | jq .data.client_id | tr -d '"')
echo "{\"allowed_client_ids\": \"$CLIENT_ID\"}" > payload.json
curl --header "X-Vault-Token: $VAULT_TOKEN" --request POST --data @payload.json $VAULT_ADDR/v1/identity/oidc/key/$KEY

echo "*** access granted!"
