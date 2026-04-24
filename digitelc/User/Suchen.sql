-- User suchen
SELECT
	-- Users-Table
	u.UserName,
	u.FirstName,
	u.LastName,
	u.TuqReference,

	-- ExaminationCenters-Table (Child)
	c.Name AS 'Prüfungzentrum',
	c.ExaminationCenterSapId AS SAPId,
	c.IsBlocked,

	-- ExaminationCenters-Table (Parent)
	p.Name AS Gruppenkopf,
	p.ExaminationCenterSapId AS SAPId,
	p.IsBlocked AS IsBlocked

FROM
	Users AS u

LEFT JOIN
	ExaminationCenters AS c
	ON u.ExaminationCenterCommunityId = TRY_CONVERT(uniqueidentifier, c.ExaminationCenterCommunityId)

LEFT JOIN
	ExaminationCenters AS p
	ON c.ExaminationCenterCommunityParentId = p.ExaminationCenterCommunityId

WHERE
	u.UserName IN ('cvetanka@speakeasy-munich.de', 'iryna@speakeasy.hamburg')
    -- u.Email = ''