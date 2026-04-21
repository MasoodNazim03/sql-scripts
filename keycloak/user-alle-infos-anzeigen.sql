SELECT
	u.username,
--	u.email,
	u.first_name,
	u.last_name,
    r.name AS roles,
    ua.name AS "Attribute-Name",
    ua.value AS "Attribute-Value"

FROM
    user_entity u

-- Rollen
LEFT JOIN user_role_mapping urm -- Zuordnungstabelle
    ON urm.user_id = u.id
LEFT JOIN keycloak_role r -- Rollen-Tabelle
    ON r.id = urm.role_id

-- Attribute
LEFT JOIN
    user_attribute ua
    ON ua.user_id = u.id

WHERE
	u.username = 'pvadmin@browserwerk.de'
    AND r.realm_id = 'onlinewelt'
    AND r.client_role = false

