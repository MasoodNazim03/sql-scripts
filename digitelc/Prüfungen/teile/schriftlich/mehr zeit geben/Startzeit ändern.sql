--  Startzeit einer Aktion ändern
DECLARE @ExaminationNumber NVARCHAR(50) = '9209915';
DECLARE @ParticipantNumbers NVARCHAR(MAX) = 'D358667,D358669';

UPDATE egt
SET egt.ActionTimestamp = DATEADD(MINUTE, 5, egt.ActionTimestamp) -- 5 Minuten mehr geben - um zeit abzuziehen einfach ein minus vor den minuten reinschreiben
-- SET egt.ActionTimestamp =  DATEADD(MINUTE, 50, DATEADD(HOUR, 8, CAST(CAST(egt.ActionTimestamp AS DATE) AS DATETIME))) -- Feste Uhrzeit 8:50 Uhr reinschreiben

FROM
	Examinations e

INNER JOIN
	ExaminationParts ep
	ON ep.ExaminationId = e.ExaminationId

INNER JOIN
	ExaminationGroups eg
	ON eg.ExaminationPartId = ep.ExaminationPartId

INNER JOIN
	ExaminationGroupParticipants egp
	ON egp.ExaminationGroupId = eg.ExaminationGroupId

INNER JOIN
	ExaminationGroupTimeManagements egt
	ON egt.ExaminationGroupParticipantId = egp.ExaminationGroupParticipantId

INNER JOIN
	Participants p
	ON p.ParticipantId = egp.ParticipantId

WHERE
	e.ExaminationNumber = @ExaminationNumber
	AND p.ParticipantNumber IN (SELECT value FROM STRING_SPLIT(@ParticipantNumbers, ','))
	AND egt.ActionCode = 2