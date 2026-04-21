-- Prüfungsteilnehmer aktionen anzeigen
DECLARE @ExaminationNumber NVARCHAR(50) = '9208086';
--DECLARE @ParticipantNumbers NVARCHAR(MAX) = 'D339434';


SELECT
	e.ExaminationNumber,

	-- ExaminationParts - Prüfungsteile
    CASE ep.ExaminationPartType
        WHEN 1 THEN 'Oral'
        WHEN 2 THEN 'Written'
        ELSE 'Unknown'
    END AS 'Prüfungsteil',

	-- ExaminationGroups
	-- Gruppen innerhalb eines Prüfungsteil
	eg.GroupName, -- Gruppenname

	-- Prüfungsteilnehmer
    p.ParticipantNumber,
    p.FirstName,
    p.LastName,


	-- ExaminationGroupParticipants - Zuordnungstabelle
	-- Hier steht welche Teilnehmer zu dieser Gruppe gehört
	-- Hier steht welche Status ein Teilnehmer hat
    CASE egp.ParticipantStatus
        WHEN 1 THEN 'Initial'
        WHEN 2 THEN 'CodeGenerated'
        WHEN 3 THEN 'InLobby (wartet)'
        WHEN 4 THEN 'InProgress (macht gerade die Prüfung)'
        WHEN 5 THEN 'Paused'
        WHEN 6 THEN 'Completed'
        ELSE 'Unknown'
    END AS 'Prüfungsteilnehmer Status',


	-- ExaminationGroupTimeManagements
	--  In dieser Tabelle steht zu welche Zeit was gemacht wurde
	CASE egt.ActionCode
		WHEN 1 THEN 'Startzeit Warteraum'
		WHEN 2 THEN 'Prüfung wurde gestartet'
		WHEN 3 THEN 'Prüfung wurde beendet'
		WHEN 4 THEN 'Prüfung wurde Pausiert'
		WHEN 5 THEN 'Pause oder Prüfung beendet'
		ELSE 'Unknown'
	END AS 'Aktion: Was wurde gemacht?',
	FORMAT(egt.ActionTimestamp, 'dd.MM.yyyy') AS 'Aktion - Datum',
	FORMAT(egt.ActionTimestamp, 'HH:mm:ss') AS 'Aktion - Uhrzeit'
	-- , egt.ActionCode
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
	--AND p.ParticipantNumber IN (SELECT value FROM STRING_SPLIT(@ParticipantNumbers, ','))
	-- AND ep.ExaminationPartType = 2 -- Für Schriftlich
	AND ep.ExaminationPartType = 1 -- Für Mündlich
	-- AND egt.ActionCode = 2

 ORDER BY ep.ExaminationPartType, eg.GroupName, egt.ActionCode, p.ParticipantNumber