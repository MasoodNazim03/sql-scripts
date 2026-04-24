-- Hierarchie 2
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
    e.ExamSubjectNumber,
    e.ScheduledAt,
    es.Title

FROM
	Examinations e -- Prüfungen

INNER JOIN ExamSubjects es ON es.Number = e.ExamSubjectNumber





