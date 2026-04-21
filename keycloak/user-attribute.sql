SELECT
    ua.name,
    ua.value
FROM
    user_attribute ua
INNER JOIN
    user_entity u
ON u.id = ua.user_id
WHERE
    u.username = 'pvadmin@browserwerk.de'