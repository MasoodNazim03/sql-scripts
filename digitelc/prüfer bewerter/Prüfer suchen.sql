-- Nach ein Prüfer suchen
-- Welche Lizenzen hat ein Prüfer/Bewerter?

DECLARE @Usernames NVARCHAR(MAX) = 'pruefer-prod3@placeholder.org';

SELECT
	-- Users
	u.UserName,
	u.FirstName,
	u.LastName,
	u.TuqReference,

    -- UserRoles-Table
    CASE r.RoleCode
        WHEN 1 THEN 'Admin'
        WHEN 2 THEN 'TelcUser'
        WHEN 3 THEN 'Examiner (Prüfer)'
        WHEN 4 THEN 'Assessor (Bewerter)'
        WHEN 5 THEN 'ExaminationCenterEmployee'
        WHEN 6 THEN 'ExaminationCenterAdmin'
        ELSE 'Unknown'
    END AS RoleName,

	-- AssessmentPersons
	-- p.AssessmentPersonType,

	-- AssessmentPersonLicenses
	l.Code AS Lizenzcode,
	l.Name AS Lizenzname,
	FORMAT(l.LicenseStartDate, 'dd.MM.yyyy') AS Start,
	FORMAT(l.LicenseEndDate, 'dd.MM.yyyy') AS Ende

FROM
	Users AS u

LEFT JOIN
	UserRoles AS r
    ON u.UserId = r.UserId

LEFT JOIN
	AssessmentPersons AS p
	ON u.TuqReference = p.TuqReference

LEFT JOIN
	AssessmentPersonLicenses AS l
	ON p.AssessmentPersonId = l.AssessmentPersonId

WHERE
	  u.UserName IN (SELECT value FROM STRING_SPLIT(@Usernames, ','))
	  -- AND
	  -- l.Code = 99001

