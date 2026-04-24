-- Mündliche Paare Hierarchie

DECLARE @ExaminationNumber NVARCHAR(50) = '9213324';
--DECLARE @ParticipantNumbers NVARCHAR(MAX) = 'D339434';


SELECT DISTINCT
	e.ExaminationNumber e,
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
    END AS 'Ausschlussgrund',

    -- Mündliche Paare
    op.PairName,
    CASE op.OralPairStatus
        WHEN 1 THEN 'Initial'
        WHEN 2 THEN 'In Preparation'
        WHEN 3 THEN 'In Progress'
        WHEN 4 THEN 'Paused'
        WHEN 5 THEN 'Completed'
        ELSE 'Unknown'
    END AS 'Paarstatus',
	FORMAT(op.CreatedAt, 'dd.MM.yyyy') AS 'Erzeugt - Datum',
    FORMAT(op.CreatedAt AT TIME ZONE 'UTC' AT TIME ZONE 'Central European Standard Time', 'HH:mm') AS 'Erzeugt - Uhrzeit-DE',
    u1.UserName AS 'Prüfer1',
    u2.UserName AS 'Prüfer2',

	-- Prüfungsteilnehmer
    p.ParticipantNumber,
    p.FirstName,
    p.LastName

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
	OralPairs op -- Mündliche Paare
    ON op.ExaminationGroupId = egp.ExaminationGroupId

INNER JOIN
	Users u1
	ON u1.UserId = op.ExaminerFirstId

INNER JOIN
	Users u2
	ON u2.UserId = op.ExaminerSecondId

INNER JOIN
	OralPairParticipants opp -- Zuordnungstabelle - Welche Teilnehmer gehört zu eine Paar.
    ON opp.OralPairId = op.OralPairId

INNER JOIN
	Participants p -- Teilnehmer die zu ein Paar gehört
	ON p.ParticipantId = opp.ParticipantId

WHERE
	e.ExaminationNumber = @ExaminationNumber
	--AND p.ParticipantNumber IN (SELECT value FROM STRING_SPLIT(@ParticipantNumbers, ','))
	AND ep.ExaminationPartType = 1 -- Für Mündlich