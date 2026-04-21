SELECT
	u.username,
	u.email,
	u.first_name,
	u.last_name,
	u.realm_id
FROM
    user_entity u
WHERE
	u.username = 'mntest001@placeholder.org'