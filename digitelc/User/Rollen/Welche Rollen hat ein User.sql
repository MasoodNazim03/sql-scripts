-- Welche Rolle hat ein User?
SELECT
    -- Users-Table
    u.UserName,
    u.Email,
    u.FirstName,
    u.LastName,
    u.TuqReference,

    -- UserRoles-Table
    r.RoleCode,

    CASE r.RoleCode
        WHEN 1 THEN 'Admin'
        WHEN 2 THEN 'TelcUser'
        WHEN 3 THEN 'Examiner (Prüfer)'
        WHEN 4 THEN 'Assessor (Bewerter)'
        WHEN 5 THEN 'ExaminationCenterEmployee'
        WHEN 6 THEN 'ExaminationCenterAdmin'
        ELSE 'Unknown'
    END AS RoleName

    , r.UserRoleId
FROM
    Users u
LEFT JOIN UserRoles r
    ON u.UserId = r.UserId

WHERE
     u.UserName IN ('m.nazim@telc.net')
	-- u.UserId = '726DD990-B002-F111-832E-6045BD1694D6'

ORDER BY RoleCode