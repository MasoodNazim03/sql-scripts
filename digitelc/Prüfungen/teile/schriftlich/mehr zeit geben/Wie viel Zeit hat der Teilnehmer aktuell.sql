-- Wie viel Zeit hat der Teilnehmer aktuell

DECLARE @ExaminationNumber NVARCHAR(50) = '9209915';
DECLARE @ParticipantNumbers NVARCHAR(MAX) = 'D358667,D358669';

SELECT
	e.ExaminationNumber AS OrdernID,

	-- ExaminationParts - Prüfungsteile
    CASE ep.ExaminationPartType
        WHEN 1 THEN 'Oral'
        WHEN 2 THEN 'Written'
        ELSE 'Unknown'
    END AS 'Prüfungsteil',

	-- ExaminationGroups
	-- eg.GroupName,

	-- Prüfungsteilnehmer
    -- p.ParticipantNumber,
    p.FirstName,
    p.LastName,

	-- ExaminationGroupTimeManagements
	--  In dieser Tabelle steht zu welche Zeit was gemacht wurde
	CASE egt.ActionCode
		WHEN 1 THEN 'Startzeit Warteraum'
		WHEN 2 THEN 'gestartet'
		WHEN 3 THEN 'beendet'
		WHEN 4 THEN 'Pausiert'
		WHEN 5 THEN 'Pauseende'
		ELSE 'Unknown'
	END AS 'Aktion',
	FORMAT(egt.ActionTimestamp, 'dd.MM.yyyy') AS 'Datum', -- Aktion
	FORMAT(egt.ActionTimestamp, 'HH:mm:ss') AS 'Uhrzeit'
	, egt.ActionCode AS Code
	-- , egt.*
	-- , egt.ActionTimestamp

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

LEFT JOIN
	ExaminationGroupTimeManagements egt -- Zu welche Zeit wurde was gemacht
	ON egt.ExaminationGroupParticipantId = egp.ExaminationGroupParticipantId

WHERE
	e.ExaminationNumber = @ExaminationNumber
	AND p.ParticipantNumber IN (SELECT value FROM STRING_SPLIT(@ParticipantNumbers, ','))
	AND ep.ExaminationPartType = 2 -- Für Schriftlich
	-- AND egt.ActionCode = 2

 ORDER BY e.ExaminationNumber, ep.ExaminationPartType, egt.ActionCode
          -- 'Prüfungsteil', eg.GroupName,
