-- Welche rollen hat ein User?
SELECT
    u.username,
    u.email,
    r.name
FROM
    keycloak_role r -- Rollentabelle
LEFT JOIN user_role_mapping urm -- Zuordnungstabelle
    ON urm.role_id = r.id
LEFT JOIN user_entity u -- Usertabelle
    ON u.id = urm.user_id
WHERE
    u.username = 'mntest001@placeholder.org'
    --AND r.realm_id = 'onlinewelt'
    AND r.client_role = false