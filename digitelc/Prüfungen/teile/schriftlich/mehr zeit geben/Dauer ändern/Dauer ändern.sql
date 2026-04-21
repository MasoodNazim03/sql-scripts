-- Dauer (MaxDuration) eines Prüfungs für einen bestimmten Teilnehmer ändern.
-- Damit wenn eine Prüfung gestartet wird, ein bestimmte Person die unten
-- eingegebene Zeit als Gesamtzeit für die Schriftliche Prüfungsteil hat.

DECLARE @ExaminationNumber NVARCHAR(50) = '9210103';
-- DECLARE @ParticipantNumbers NVARCHAR(MAX) = 'D355612';


UPDATE t
SET t.MaxDuration = '00:40:00'
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

WHERE
	e.ExaminationNumber = @ExaminationNumber
	-- AND p.ParticipantNumber IN (SELECT value FROM STRING_SPLIT(@ParticipantNumbers, ','))