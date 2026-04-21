DECLARE @ExaminationNumber NVARCHAR(50) = '9208086';
--DECLARE @ParticipantNumbers NVARCHAR(MAX) = 'D339434';


SELECT
	e.ExaminationNumber,
    CASE e.ExaminationStatus
        WHEN 1 THEN 'Upcoming '
        WHEN 2 THEN 'InPreparation'
        WHEN 3 THEN 'InProgress'
        WHEN 4 THEN 'Completed'
        WHEN 5 THEN 'Terminated (abgebrochen)'
        ELSE 'Unknown'
    END AS 'Prüfungsstatus',

	-- ExaminationParts - Prüfungsteile
    CASE ep.ExaminationPartType
        WHEN 1 THEN 'Oral'
        WHEN 2 THEN 'Written'
        ELSE 'Unknown'
    END AS 'Prüfungsteil',
    CASE ep.ExaminationPartStatus
        WHEN 1 THEN 'Upcoming '
        WHEN 2 THEN 'InPreparation'
        WHEN 3 THEN 'InProgress'
        WHEN 4 THEN 'Paused'
        WHEN 5 THEN 'Completed'
        ELSE 'Unknown'
    END AS 'Prüfungsteil Status',

	-- ExaminationGroups
	-- Gruppen innerhalb eines Prüfungsteil
	eg.GroupName, -- Gruppenname
	--eg.ParticipantLimit,
    CASE eg.ExaminationOralGroupStatus
        WHEN 1 THEN 'Initial'
        WHEN 2 THEN 'Paare wurden generiert' -- PairsCreated
        WHEN 3 THEN 'InProgress' -- Wurde gestartet
        WHEN 4 THEN 'Vollständig' -- Evaluated
        ELSE 'Unknown'
    END AS 'Mündliche Gruppen Status',

	-- Prüfungsteilnehmer
    p.ParticipantNumber,
    p.FirstName,
    p.LastName,


	-- ExaminationGroupParticipants - Zuordnungstabelle
	-- Hier steht welche Teilnehmer zu dieser Gruppe gehört
	-- Hier steht welche Status ein Teilnehmer hat
	-- egp.ParticipantStatus,
	-- egp.ExclusionCriterionType,
    CASE egp.ParticipantStatus
        WHEN 1 THEN 'Initial'
        WHEN 2 THEN 'CodeGenerated'
        WHEN 3 THEN 'InLobby (wartet)'
        WHEN 4 THEN 'InProgress (macht gerade die Prüfung)'
        WHEN 5 THEN 'Paused'
        WHEN 6 THEN 'Completed'
        ELSE 'Unknown'
    END AS 'Prüfungsteilnehmer Status',

    CASE egp.ExclusionCriterionType
        WHEN 1 THEN 'Kein Ausschluss'
        WHEN 2 THEN 'Täuschungsversuch'
        WHEN 3 THEN 'Auschluss'
        WHEN 4 THEN 'Abgebrochen'
        WHEN 5 THEN 'Abwesend'
        ELSE 'Unknown'
    END AS 'Ausschlussgrund'

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
	--AND p.ParticipantNumber IN (SELECT value FROM STRING_SPLIT(@ParticipantNumbers, ','))
	-- AND ep.ExaminationPartType = 2 -- Für Schriftlich
	AND ep.ExaminationPartType = 1 -- Für Mündlich


 ORDER BY e.ExaminationNumber, ep.ExaminationPartType, eg.GroupName, p.ParticipantNumber