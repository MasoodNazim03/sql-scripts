-- Mündliche Prüfungsteil Status ändern
DECLARE @ExaminationNumber NVARCHAR(50) = '9020796';

/**
    CASE ep.ExaminationPartStatus
        WHEN 1 THEN 'Upcoming '
        WHEN 2 THEN 'InPreparation'
        WHEN 3 THEN 'InProgress'
        WHEN 4 THEN 'Paused'
        WHEN 5 THEN 'Completed'
        ELSE 'Unknown'
    END AS 'Prüfungsteil Status',
**/

UPDATE ep
SET ep.ExaminationPartStatus = 5

FROM
	Examinations e -- Prüfungen

INNER JOIN
	ExaminationParts ep --  Prüfungsteile
	ON ep.ExaminationId = e.ExaminationId

WHERE
	e.ExaminationNumber = @ExaminationNumber
	AND ep.ExaminationPartType = 1 -- Für Mündliche Prüfungsteil

