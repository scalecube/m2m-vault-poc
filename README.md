# m2m-vault-poc
POC for M2M authorization driven by Vault Identities Secrets Engine.

## Resources
https://www.vaultproject.io/docs/secrets/identity/index.html
https://www.vaultproject.io/api/secret/identity/index.html
https://www.vaultproject.io/api/secret/identity/entity.html
https://learn.hashicorp.com/vault/identity-access-management/iam-policies
https://github.com/hashicorp/hcl

## Challenge
Est. common machine-to-machine autorization method/approach for containers authenticated in Vault.

## Preconditions

Vault 1.3.2

## Scripts

### `set_demo_vault.sh`
Enables userpass auth method for POC. Must be run once initially.

### `add_service.sh`
Provisions service using userpass auth method (creates entity eventually). Arguments: `$0` -- service name.

Example output:  
```
$ ./add_service.sh gateway
### creating service entity: gateway
### created service entity: gateway, entity: entity_6c0ab554/2e04a4c6-6c40-239f-ce7e-e56927bf591b, token: s.K7lUQmq85encHJFfsCb4Ift2
```


### `grant_access.sh`
Grants access to service consumer to issue jwt token. Essentially this script updates policies of two entities (service client and service provider). 
Arguments:
`$0` -- service provider entity_id.
`$1` -- service client entity_id.
`$2` -- access identifier string.

Example output:
```
$ ./grant_access.sh b3d567ac-7bcd-5390-f8f2-00fb429fa7e2 1a8e9852-378e-7c86-9768-8d6d7737f0f9 operations
*** granting access: [operations] from provider: b3d567ac-7bcd-5390-f8f2-00fb429fa7e2 to consumer: 1a8e9852-378e-7c86-9768-8d6d7737f0f9
Success! Uploaded policy: b3d567ac-7bcd-5390-f8f2-00fb429fa7e2.1a8e9852-378e-7c86-9768-8d6d7737f0f9.operations
```
What this policy stands for: 
```
$ vault policy read b3d567ac-7bcd-5390-f8f2-00fb429fa7e2.1a8e9852-378e-7c86-9768-8d6d7737f0f9.operations
path "identity/oidc/token/b3d567ac-7bcd-5390-f8f2-00fb429fa7e2.1a8e9852-378e-7c86-9768-8d6d7737f0f9.operations" {capabilities=["create", "read"]}
```
This means entity (which has this policy installed) can ask for the jwt token on path `identity/oidc/token...`.

### `get_access_token.sh`
Requests jwt token. 

Arguments:
`$0` -- service consumer entity client token.
`$1` -- service provider entity_id (**who** generates?).
`$2` -- service consumer entity_id (for **whom** to generate?)
`$3` -- access identifier string.

Example output:
```
arvy@arvy:~/Workspace/m2m-vault-poc$ ./get_access_token.sh s.K7lUQmq85encHJFfsCb4Ift2 622a13ad-b656-1832-cc8b-ccce74e398c8.2e04a4c6-6c40-239f-ce7e-e56927bf591b.operations
>>> generating jwt tokent on access request: 622a13ad-b656-1832-cc8b-ccce74e398c8.2e04a4c6-6c40-239f-ce7e-e56927bf591b.operations
{"request_id":"093cc3d4-c6e3-0d95-2242-1014f7b41d53","lease_id":"","renewable":false,"lease_duration":0,"data":{"client_id":"HXyiCY64j1Mauq2ayGVxGQH1lV","token":"eyJhbGciOiJSUzI1NiIsImtpZCI6IjExMTcwNTI4LTZlOWYtYzhmYy0yODdjLWEyMjYwYmZmYmRjNiJ9.eyJhbGxvd2VkX2FjdGlvbnMiOlsibmV3SW5zdHJ1bWVudCIsImFzc2lnbkNhbGVuZGFyIiwiYXNzaWduQ2JyIiwib3BlcmF0aW9uRXZlbnRzIl0sImF1ZCI6IkhYeWlDWTY0ajFNYXVxMmF5R1Z4R1FIMWxWIiwiZXhwIjoxNTg2MDkyOTUzLCJpYXQiOjE1ODYwMDY1NTMsImlzcyI6Imh0dHA6Ly8wLjAuMC4wOjgyMDAvdjEvaWRlbnRpdHkvb2lkYyIsIm5hbWVzcGFjZSI6InJvb3QiLCJzdWIiOiIyZTA0YTRjNi02YzQwLTIzOWYtY2U3ZS1lNTY5MjdiZjU5MWIifQ.oLebi-1CVgw2iKaizSQ7CAZbdqEjQ3B95GzPz3tTF2TcI3dQvP92ftu-w3TaLKEzm1TSHovb6FYQl0Q5IdKsrRgI-Ki5RHu9CuyuKOsg8HmV_M6tOVAh6BCAsSOL3PVpCmH-lQnQxfMn4kKJBYS6IgqC73wUDelSmpeFFQRGQrnjsV29Dzd6R5v8wqZ-tB6rvUD_WUMP21T_IS-QxTYP2n8yVWKy89ugbK9L94gK0Ye16WSji9ZQ_26vkDClfTqvgvC0hAV-hFOlqt2Edtb0X605yHr4C5Izej2IOC4AKhlrZlK3GmtPWKB4Cl_bnrvbWenAVDToxmFUlR3toHtwoQ","ttl":86400},"wrap_info":null,"warnings":null,"auth":null}
```
