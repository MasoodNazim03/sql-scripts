SELECT
	u.username,
	u.first_name,
	u.last_name,
--    r.name AS roles,

    CASE r.name
        WHEN 'default-roles-onlinewelt' THEN 'ja'
        ELSE 'nein'
    END AS "default-role-vorhanden",

    CASE r.name
    WHEN 'offline_access' THEN 'ja'
        ELSE 'nein'
    END AS "offline-role-vorhanden"

FROM
    user_entity u

-- Rollen
LEFT JOIN user_role_mapping urm -- Zuordnungstabelle
    ON urm.user_id = u.id
LEFT JOIN keycloak_role r -- Rollen-Tabelle
    ON r.id = urm.role_id

WHERE
	-- u.username = 'pvadmin@browserwerk.de'
    u.username = 'mntest001@placeholder.org'
    AND
    r.realm_id = 'onlinewelt'
    AND r.client_role = false
    -- Rollen
    AND LOWER(r.name) NOT IN ('default-roles-onlinewelt', 'offline_access')

ORDER BY
  	u.username
