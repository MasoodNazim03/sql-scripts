-- 1 'Admin'
-- 2 'TelcUser'
-- 3 'Examiner (Prüfer)'
-- 4 'Assessor (Bewerter)'
-- 5 'ExaminationCenterEmployee'
-- 6 'ExaminationCenterAdmin'

DELETE r
FROM UserRoles r
JOIN
	Users u
	ON u.UserId = r.UserId
WHERE
	u.UserName = '1383810'
	AND r.RoleCode = 3;