-- Mündliche Paar Status ändern
/**
    CASE op.OralPairStatus
        WHEN 1 THEN 'Initial'
        WHEN 2 THEN 'In Preparation'
        WHEN 3 THEN 'In Progress'
        WHEN 4 THEN 'Paused'
        WHEN 5 THEN 'Completed'
        ELSE 'Unknown'
    END AS 'Paarstatus',
**/

DECLARE @ExaminationNumber NVARCHAR(50) = '9020608';

-- Testen
-- SELECT e.ExaminationNumber e, op.*

UPDATE op SET op.OralPairStatus = 5
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

WHERE
	e.ExaminationNumber = @ExaminationNumber
	--AND p.ParticipantNumber IN (SELECT value FROM STRING_SPLIT(@ParticipantNumbers, ','))
	AND ep.ExaminationPartType = 1 -- Für Mündlich
	-- AND op.PairName = 'Paar 1'