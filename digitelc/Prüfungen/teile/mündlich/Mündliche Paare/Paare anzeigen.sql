-- Mündliche Paare

DECLARE @ExaminationNumber NVARCHAR(50) = '9213324';
--DECLARE @ParticipantNumbers NVARCHAR(MAX) = 'D339434';


SELECT DISTINCT
	e.ExaminationNumber e,

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
    FORMAT(op.CreatedAt AT TIME ZONE 'UTC' AT TIME ZONE 'Central European Standard Time', 'dd.MM.yyyy HH:mm') AS 'Erzeugt - DE-Zeit',
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