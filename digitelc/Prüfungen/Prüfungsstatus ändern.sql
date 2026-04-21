-- Prüfungsstatus ändern
/**
    CASE e.ExaminationStatus
        WHEN 1 THEN 'Upcoming '
        WHEN 2 THEN 'InPreparation'
        WHEN 3 THEN 'InProgress'
        WHEN 4 THEN 'Completed'
        WHEN 5 THEN 'Terminated (abgebrochen)'
        ELSE 'Unknown'
    END AS 'Prüfungsstatus',
**/

DECLARE @ExaminationNumber NVARCHAR(50) = '9208086';

UPDATE
    Examinations
SET
    ExaminationStatus = 4
WHERE
    ExaminationNumber = @ExaminationNumber


