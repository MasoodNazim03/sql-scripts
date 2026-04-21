SELECT
    g.name AS "Prüfungszentrum Name",
    ga.value AS SAPID,
    (SELECT value FROM group_attribute WHERE group_id = g.id AND name = 'BYD_EXT_REF') AS ParentSAPID,
    (SELECT name FROM keycloak_group WHERE id = g.parent_group) AS "Hauptlizenznehmer"
    -- , ga.*
FROM
    keycloak_group g

LEFT JOIN group_attribute ga
    ON ga.group_id = g.id
    AND ga.name = 'BYD_EXT_REF'

WHERE g.realm_id = 'onlinewelt';

-- Welche Attributen gibt es überhaupt
-- select distinct ga.name from group_attribute ga;