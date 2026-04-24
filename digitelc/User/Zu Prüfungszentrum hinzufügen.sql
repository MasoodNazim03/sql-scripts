-- User zu einer Prüfungzentrum hinzufügen
UPDATE
    u
SET
    u.ExaminationCenterCommunityId = e.ExaminationCenterCommunityId

FROM
	Users u

INNER JOIN ExaminationCenters e
    ON e.ExaminationCenterSapId = 1041898 -- Prüfungszentrum ID zu dem der User gehören soll

WHERE
	u.UserName = 'elif.dag@das-akademie.de' -- User der geändert werden soll