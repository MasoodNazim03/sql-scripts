-- Neue Rolle zuweisen
INSERT INTO user_role_mapping (role_id, user_id)
SELECT
    r.id,
    u.id
FROM keycloak_role r, -- Rollentabelle
     user_entity u -- Usertabellle
WHERE r.name = 'pv_admin'
  AND r.realm_id = 'onlinewelt'
  AND u.realm_id = 'onlinewelt'
  AND u.username IN ('mntest001@placeholder.org')
  AND NOT EXISTS (
      SELECT 1
      FROM user_role_mapping urm -- Zuordnungstabelle
      WHERE urm.role_id = r.id
        AND urm.user_id = u.id
  );
-- Das funktioniert leider nicht. Die Rolle ist weder in keycloak-Oberfläche sichtbar noch kann der User auf Community zugreifen.



