-- Wie viele Prüfungen fanden bisher statt

SELECT
    e.ExamSubjectNumber AS 'Prüfungsformat',
    es.Title,
	COUNT(DISTINCT e.ExaminationNumber) AS 'Prüfungen',
	COUNT(DISTINCT egp.ParticipantId) AS 'Anzahl Teilnehmer'

FROM
	Examinations e -- Prüfungen

INNER JOIN
	ExaminationParts ep --  Prüfungsteile
	ON ep.ExaminationId = e.ExaminationId

INNER JOIN
	ExamSubjects es
	ON es.Number = e.ExamSubjectNumber

INNER JOIN
	ExaminationGroups eg -- Gruppen innerhalb Prüfungsparts
	ON eg.ExaminationPartId = ep.ExaminationPartId

INNER JOIN
	ExaminationGroupParticipants egp -- Zuordnungstabelle Gruppe und Prüfungsteilnehmer die zu dieser Gruppe gehören
	ON egp.ExaminationGroupId = eg.ExaminationGroupId

WHERE
    e.ExaminationCenterId != '0EB10284-23E0-F011-8D4D-0022485D0D50' -- 1032070 - telc Einzellizenz Testkunde ausschließen
    AND CONVERT(date, e.ScheduledAt) = '2026-04-21'

GROUP BY e.ExamSubjectNumber, es.Title
ORDER BY COUNT(egp.ParticipantId) DESC