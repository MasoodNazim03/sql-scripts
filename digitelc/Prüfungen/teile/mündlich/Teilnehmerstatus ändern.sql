-- Prüfungsteilnehmer Status für die Mündliche Prüfungsteil ändern
/**
    CASE egp.ParticipantStatus
        WHEN 1 THEN 'Initial'
        WHEN 2 THEN 'CodeGenerated'
        WHEN 3 THEN 'InLobby (wartet)'
        WHEN 4 THEN 'InProgress (macht gerade die Prüfung)'
        WHEN 5 THEN 'Paused'
        WHEN 6 THEN 'Completed'
        ELSE 'Unknown'
    END AS 'Prüfungsteilnehmer Status',
**/

DECLARE @ExaminationNumber NVARCHAR(50) = '9208086';
--DECLARE @ParticipantNumbers NVARCHAR(MAX) = 'D339434';

UPDATE egp
SET egp.ParticipantStatus = 6
FROM
	Examinations e -- Prüfungen

INNER JOIN
	ExaminationParts ep --  Prüfungsteile
	ON ep.ExaminationId = e.ExaminationId

INNER JOIN
	ExaminationGroups eg -- Gruppen innerhalb Prüfungsparts
	ON eg.ExaminationPartId = ep.ExaminationPartId

INNER JOIN
	ExaminationGroupParticipants egp -- Zuordnungstabelle Gruppe und Prüfungsteilnehmer die zu dieser Gruppe gehören
	ON egp.ExaminationGroupId = eg.ExaminationGroupId

INNER JOIN
	Participants p -- Teilnehmer
	ON p.ParticipantId = egp.ParticipantId

WHERE
	e.ExaminationNumber = @ExaminationNumber
	AND p.ParticipantNumber IN (SELECT value FROM STRING_SPLIT(@ParticipantNumbers, ','))
	AND ep.ExaminationPartType = 1 -- Für Mündliche Prüfungsteil