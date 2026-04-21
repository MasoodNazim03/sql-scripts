-- Wie lange dauert die Prüfung aktuell?

DECLARE @ExaminationNumber NVARCHAR(50) = '9210103';
-- DECLARE @ParticipantNumbers NVARCHAR(MAX) = 'D355612';

SELECT DISTINCT
	e.ExaminationNumber,

	-- Prüfungsteilnehmer
    p.ParticipantNumber,
    p.FirstName,
    p.LastName,
	es.Number AS 'Prüfungsformat',
	t.MaxDuration AS 'Dauer'

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

INNER JOIN
	Tests t
	ON t.ParticipantId = p.ParticipantId
	AND t.ExaminationId = e.ExaminationId

INNER JOIN
	ExamSubjects es
	ON es.ExamSubjectId = t.ExamSubjectId

WHERE
	e.ExaminationNumber = @ExaminationNumber
	-- AND p.ParticipantNumber IN (SELECT value FROM STRING_SPLIT(@ParticipantNumbers, ','))