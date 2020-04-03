path "identity/oidc/role/{{identity.entity.id}}.*" {
  capabilities = [ "read", "create", "delete", "list" ]
}
path "identity/oidc/key/{{identity.entity.id}}.*" {
  capabilities = [ "read", "create", "delete", "list" ]
}
