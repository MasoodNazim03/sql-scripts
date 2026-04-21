-- Welche rollen haben wir im System?
SELECT
    r.name,
    r.realm_id
    --, r.description
FROM
    keycloak_role r
WHERE
    realm_id = 'onlinewelt'
    AND r.client_role = false